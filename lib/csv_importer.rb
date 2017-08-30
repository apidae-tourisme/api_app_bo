require 'csv'
require 'sitra_client'
require 'couchrest'

class CsvImporter

  CATEGORIES = {
      "Région Auvergne-Rhône-Alpes" => 'f6b72a7e-4921-44e4-8a07-12f4ed7266bd',
      "Région Provence Alpes Côte d'Azur" => '498fc072-0703-40f9-a495-ae106d02bc9d',
      "Région Ile de France" => '41279833-58f5-4812-81b0-c62f9d503655',
      "Département du Tarn" => '3b332a90-fd60-402d-8e0c-f9ac2f401bf8',
      "Secteur Suisse" => '202edc4d-7f2d-4559-b667-ca1910b6b131',
      "Communauté des développeurs" => 'f80a9ea9-ee7e-44c5-8f77-4f528f802f5b',
      "Ecoles et centres de formation" => 'b570f999-4414-42c4-817c-2d53c8f58452'
  }

  def self.import_users(host, db_name, csv_file, ref_file)
    refs = {}

    server = CouchRest.new(host)
    db = server.database!(db_name)

    CSV.foreach(ref_file, headers: true, col_sep: ',', encoding: 'UTF-8') do |row|
      refs[row.field('apidae_id')] = row.field('apiapp_id')
    end

    # id;lastName;firstName;email;phoneNumber;membre;adresse;codePostal;communeId;communeCode;communeNom;communeCodePostal;nomEntite;idEntite;firstName;gsmNumber;profession;facebook;twitter;nomEntite;presentation;adresse2;bureauDistribution;cedex
    CSV.foreach(csv_file, headers: true, col_sep: ';', encoding: 'UTF-8') do |row|
      existing = db.view 'search/by-email', {}, keys: [row.field('email').downcase]
      puts "existing : #{existing}"
      if !existing || existing['rows'].blank?
        puts "inserting new user seed #{row.field('email')}"
        user_seed = {
            external_id: row.field('id'),
            name: [format_name(row.field('firstName')), format_name(row.field('lastName'))].join(' '),
            type: 'Person',
            email: row.field('email'),
            description: row.field('profession'),
            address: fields_values(row, 'adresse', 'adresse2', 'codePostal', 'communeNom').join(' '),
            created_at: Time.current.utc.strftime('%FT%H:%M:%SZ'),
            updated_at: Time.current.utc.strftime('%FT%H:%M:%SZ'),
            scope: 'apidae',
            connections: [],
            urls: fields_values(row, 'email', 'phoneNumber', 'gsmNumber', 'facebook', 'twitter')
        }
        result = db.save_doc(user_seed)
        if result['ok']
          puts "user saved - adding connections"
          entity_id = row.field('idEntite')
          unless entity_id.blank? || refs[entity_id].blank?
            puts "entity matched #{refs[entity_id]}"
            user_seed[:connections] = [refs[entity_id]]
            db.save_doc(user_seed)
            entity_seed = db.get(refs[entity_id])
            entity_seed[:connections] << user_seed['_id']
            db.save_doc(entity_seed)
          end
        end
      else
        puts "skipping existing user #{row.field('email')}"
      end
    end
  end

  def self.format_name(name)
    unless name.blank?
      name.split('-').map {|n| n.capitalize}.join('-')
    end
  end

  def self.fields_values(row, *fields)
    fields.map {|f| format_value(f, row.field(f))}.select {|f| !f.blank?}
  end

  def self.format_value(field, val)
    unless val.blank?
      case field
        when 'phoneNumber', 'gsmNumber'
          new_val = val.gsub('(0)', '').gsub('.', '').gsub(/\s/, '')
          if /^\+?\d{7,}$/.match(new_val)
            new_val = new_val.gsub('+', '00')
            new_val.start_with?('0') ? new_val : ('0' + new_val)
          else
            new_val
          end
        else
          val
      end
    end
  end

  def self.import_members(host, db_name, csv_file, ref_file)
    refs = {}

    SitraClient.configure(Rails.application.config.apidae_config)

    server = CouchRest.new(host)
    db = server.database!(db_name)

    CSV.foreach(ref_file, headers: true, col_sep: ',', encoding: 'UTF-8') do |row|
      refs[row.field('apidae_id')] = row.field('apiapp_id')
    end

    # id;dateCreation;nom;secteurNom;idEntite;departement;proprietaire
    CSV.foreach(csv_file, headers: true, col_sep: ';', encoding: 'UTF-8') do |row|
      entity_id = row.field('idEntite')
      unless refs.has_key?(entity_id)
        # https://apiapp-db.apidae-tourisme.com/api-app_prod/_design/search/_view/by-name?limit=20&reduce=false
        existing = db.view 'search/by-name', {}, keys: [row.field('nom').downcase]
        puts "existing : #{existing}"
        if !existing || existing['rows'].blank?
          entity = get_apidae_object(entity_id)
          if entity
            puts "entity matched - inserting new member seed"
            contact_entries = entity.information[:moyensCommunication] || []
            member_seed = {
                external_id: row.field('id'),
                name: row.field('nom'),
                type: 'Organization',
                address: entity.address,
                created_at: Time.current.utc.strftime('%FT%H:%M:%SZ'),
                updated_at: Time.current.utc.strftime('%FT%H:%M:%SZ'),
                scope: 'apidae',
                connections: [],
                urls: contact_entries.collect {|c| c[:coordonnees][:fr]}
            }
            result = db.save_doc(member_seed)
            if result['ok']
              puts "member saved - adding connections"
              tag_name = row.field('secteurNom')
              unless tag_name.blank? || !CATEGORIES.has_key?(tag_name)
                refs[entity_id] = member_seed['_id']
                member_seed[:connections] = [CATEGORIES[tag_name]]
                db.save_doc(member_seed)
                tag_seed = db.get(CATEGORIES[tag_name])
                tag_seed[:connections] << member_seed['_id']
                db.save_doc(tag_seed)
              end
            end
          end
        else
          if existing['rows'].any? && existing['rows'][0]['id']
            refs[entity_id] = existing['rows'][0]['id']
          end
          puts "skipping existing member #{row.field('nom')}"
        end
      end
    end

    CSV.open(ref_file, 'w') do |csv|
      csv << ['apidae_id', 'apiapp_id']
      refs.each_pair do |k, v|
        csv << [k, v]
      end
    end

  end

  def self.get_apidae_object(id)
    puts "get_apidae_object : #{id}"
    config = Rails.application.config.apidae_config
    res = {}

    unless id.blank?
      begin
        response = SitraResponse.new
        open("#{config[:base_url]}/objet-touristique/#{is_legacy?(id) ? 'get-by-identifier' : 'get-by-id'}/#{id}?apiKey=#{config[:api_key]}&projetId=#{config[:site_identifier]}&responseFields=#{'id,informations.moyensCommunication,localisation.adresse,localisation.geolocalisation'}") { |f|
          f.each_line {|line| response.append_line(line)}
        }
        res = response.as_hash.merge(informationsStructure: {})
        puts "res : #{res}"
      rescue StandardError => e
        puts "object not found : #{id}"
      end
    end

    res[:id] ? TouristicObject.new(res) : nil
  end

  def self.is_legacy?(id)
    /\D/.match(id)
  end
end