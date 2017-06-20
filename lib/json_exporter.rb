# Exports all seeds as json array (for future import in another db)
# Note : pictures and history fields are skipped for now
class JsonExporter
  include Neo4j::ActiveNode

  def self.export_seeds(json_file)
    all_seeds = Neo4j::Session.current.query.match(:n).where("n.name IS NOT NULL").pluck(:n)
    puts "Exporting #{all_seeds.count} seeds to JSON"
    File.open(Rails.root.join(json_file), 'w+') do |f|
      f.write('{"seeds":[')
      all_seeds.each_with_index do |s, i|
        f.write(',') unless i == 0
        f.write(as_json(s))
      end
      f.write(']}')
    end
  end

  def self.as_json(seed)
    seed_data = {
        '_id' => seed.id.gsub('-', ''),
        'created_at' => format_time(seed.created_at),
        'updated_at' => format_time(seed.updated_at),
        'name' => seed.name,
        'description' => seed.description,
        'type' => seed.class.to_s,
        'address' => seed.address,
        'lat' => seed.latitude,
        'lng' => seed.longitude,
        'email' => seed.respond_to?(:email) ? seed.email : nil,
        'starts_at' => format_time(seed.start_date),
        'ends_at' => format_time(seed.end_date),
        'archived' => seed.archived,
        'scope' => seed.scope,
        'author' => seed.last_contributor,
        'urls' => seed.urls,
        'connections' => seed.seeds.collect {|s| s.gsub('-', '')}
    }
    JSON.generate(seed_data)
  end

  def self.format_time(val)
    val.nil? ? nil : Time.at(val).utc.strftime('%FT%H:%M:%SZ')
  end
end
