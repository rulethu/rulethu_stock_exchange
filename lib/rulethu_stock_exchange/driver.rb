require "pry"
require "open-uri"

module RulethuStockExchange
  class Driver
    class << self
      def geckodriver
        url = "https://github.com/mozilla/geckodriver/releases/download/v0.36.0/geckodriver-v0.36.0-linux64.tar.gz"
        filepath = "drivers/geckodriver.tar.gz"

        unless File.exist? filepath
          begin
            URI.open(url) do |remote_file|
              File.open(filepath, "wb") do |local_file|
                ::IO.copy_stream(remote_file, local_file)
              end
            end
            puts "Successfully downloaded to #{filepath}"
          rescue OpenURI::HTTPError => e
            puts "Failed to download: #{e.message}"
          end
        end

        file = filepath.split(".tar.gz").first
        unless File.exist? file
          `tar -zxvf #{filepath} -C ./drivers`
        end
        File.delete filepath
        file
      end
    end
  end
end
