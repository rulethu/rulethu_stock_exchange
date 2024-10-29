# frozen_string_literal: true
require "selenium-webdriver"

module RulethuStockExchange
  class Parser
    attr_reader :table

    def initialize(table)
      @table = table
    end

    def parse_zse
      tbody = table.find_element(:tag_name, "tbody")
      rows = tbody.find_elements(:tag_name, "tr")
      data_rows = []
      rows.each do |row|
        text = row.find_elements(:tag_name, "td").first.text.strip
        unless text&.upcase == "EQUITIES"
          data_rows << row unless text.empty?
        end
      end

      header_data = []
      data_rows.first.find_elements(:tag_name, "td").each do |td|
        text = td.text.strip.gsub("\n", " ") || "#"
        text = "#" if text.empty?
        header_data << text
      end

      data_rows = data_rows.slice(1, data_rows.length)

      data = []
      data_rows.each do |row|
        row_data = {}
        cells = row.find_elements :tag_name, "td"
        cells.each_with_index do |cell, index|
          key = header_data[index] || "#"
          row_data[key] = cell.text.strip
        end
        data << row_data
      end
      data
    end

    def parse
      header_data = []
      begin
        thead = table.find_element(:tag_name, "thead")
        cells = thead.find_element(:tag_name, "tr").find_elements(:tag_name, "th")
        puts "Writing header data"
        cells.each do |cell|
          header_data << cell.text
          print "."
        end
      rescue Selenium::WebDriver::Error::NoSuchElement => e
        # Handle missing header gracefully (e.g., log the error)
      end
      tbody = table.find_element(:tag_name, "tbody")
      rows = tbody.find_elements(:tag_name, "tr")
      body_data = []
      puts "\nWriting body data"
      rows.each do |row|
        data = {}
        cells = row.find_elements(:tag_name, "td")
        if header_data.empty?
          header_data = cells.map(&:text)
        end
        cells.each_with_index do |cell, index|
          data[header_data[index]] = cell.text unless header_data[index].strip.empty?
        end
        body_data << data
        print "."
      end
      body_data
    end
  end
end
