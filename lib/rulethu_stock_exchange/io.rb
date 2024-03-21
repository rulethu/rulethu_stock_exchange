# frozen_string_literal: true
require 'json'
require 'csv'
require 'time'

module RulethuStockExchange
  class IO
    def self.write_to_json_file(data, prefix)
      puts "\nWriting to JSON with prefix #{prefix}"
      date = Time.now.strftime("%d-%m-%Y")
      data_dir = Pathname.new("data") / Pathname.new(prefix)
      data_dir.mkpath
      filename = "#{data_dir}/#{date}-data.json"
      File.open(filename, 'w') do |f|
        f.write(JSON.dump(data))
      end
      filename
    end

    def self.json_to_csv(json_file)
      puts "\nConverting #{json_file} to CSV"
      data = Object.new
      File.open(json_file, 'r') do |f|
        data = JSON.parse(f.read)
      end

      filename = json_file.sub(/\.json$/, '.csv')

      CSV.open(filename, 'w') do |csv|
        csv << data.first.keys
        data.each do |row|
          csv << row.values
        end
      end
      filename
    end
  end
end
