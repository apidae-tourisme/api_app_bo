class SpreadsheetImporter

  COL_PREFIX = 'gsx$'
  VAL_KEY = '$t'

  def self.import_from(spreadsheet)
    json_data = File.read(spreadsheet)
    parsed_data = JSON.parse(json_data, symbolize_names: false)
    seeds = parsed_data['feed']['entry']
    # seeds.each do |s|
    #   import_seed(s)
    # end

    seeds.each do |s|
      import_links(s)
    end
  end

  def self.read_col(entry, col)
    entry[COL_PREFIX + col][VAL_KEY]
  end

  def self.import_seed(seed)
    seed_ref = read_col(seed, 'id')
    seed_entry = Neo4j::Session.current.query.match(n: {reference: seed_ref}).return(:n).first
    unless seed_entry
      seed_class = read_col(seed, 'label') == 'Action' ? Task : read_col(seed, 'label').constantize
      create_seed(seed_class, seed)
    end
  end

  def self.import_links(seed)
    seed_ref = read_col(seed, 'id')
    seed_relations = read_col(seed, 'link').split(',')
    seed_entry = Neo4j::Session.current.query.match(n: {reference: seed_ref}).return(:n).first
    if seed_entry && seed_relations.any?
      seed_relations.each do |rel|
        rel_entry = Neo4j::Session.current.query.match(n: {reference: rel}).return(:n).first
        unless rel_entry.nil?
          bind_seeds(seed_entry.n, rel_entry.n)
        end
      end
    end
  end

  def self.create_seed(seed_class, seed)
    timestamp = Time.current.to_i
    new_seed = seed_class.new(created_at: timestamp, updated_at: timestamp, reference: read_col(seed, 'id'),
                              name: read_col(seed, 'name'), description: read_col(seed, 'description'),
                              thumbnail: read_col(seed, 'thumbnail'))
    case new_seed
      when Competence, Concept, Event, Idea, Schema, Task
      when CreativeWork, Product
        new_seed.url = read_col(seed, 'url')
      when Organization
        new_seed.address = read_col(seed, 'location')
        new_seed.email = read_col(seed, 'email')
        new_seed.telephone = read_col(seed, 'phonenumber')
        new_seed.url = read_col(seed, 'url')
      when Person
        new_seed.firstname = read_col(seed, 'firstname')
        new_seed.lastname = read_col(seed, 'lastname')
        new_seed.role = read_col(seed, 'profession')
        new_seed.email = read_col(seed, 'email')
        new_seed.telephone = read_col(seed, 'phonenumber')
        new_seed.mobilephone = read_col(seed, 'gsmnumber')
      when Project
        # No common formatting
        # new_seed.start_date = read_col(seed, 'startdate')
        # new_seed.end_date = read_col(seed, 'enddate')
        new_seed.url = read_col(seed, 'url')
      else
        raise Exception.new("Unsupported seed type : #{seed_class}")
    end
    new_seed.save!
    new_seed
  end

  def self.bind_seeds(seed, relation)
    seed.connected_seeds << relation unless seed.connected_seeds.include?(relation)
    # case seed
    #   when Concept
    #   when Idea
    #   when Organization
    #   when Person
    #     case relation
    #       when Organization
    #         seed.organizations << relation unless seed.organizations.include?(relation)
    #       when Project
    #         seed.projects << relation unless seed.projects.include?(relation)
    #       when Competence
    #         seed.competences << relation unless seed.competences.include?(relation)
    #       when Product
    #         seed.products << relation unless seed.products.include?(relation)
    #       when Concept
    #         seed.concepts << relation unless seed.concepts.include?(relation)
    #       when Idea
    #         seed.ideas << relation unless seed.ideas.include?(relation)
    #       else
    #         puts "Unmatched relation for Person seed : #{relation.name}"
    #     end
    #   when Product
    #   when Project
    #   when Task
    #   when Concept
    #   when Schema
    #   when Competence
    #   when CreativeWork
    #   else
    #     raise Exception.new("Could not bind seed #{seed.name} with other seed #{relation.name}")
    # end
  end
end