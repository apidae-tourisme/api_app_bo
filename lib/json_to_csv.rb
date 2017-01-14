require 'csv'

class JsonToCsv
  def self.convert(json_file, csv_file, *cols)
    json_data = JSON.parse(File.read(json_file), symbolize_names: true)[:utilisateurs]
    CSV.open(csv_file, 'w') do |csv|
      csv << cols.map {|h| h.to_s}
      json_data.each do |d|
        csv << cols.collect {|col| d[col] || ''}
      end
    end
    "#{json_data.length} lignes générées"
  end
end