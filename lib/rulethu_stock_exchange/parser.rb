# frozen_string_literal: true
require 'selenium-webdriver'

module RulethuStockExchange
  class Parser
    attr_reader :table

    def initialize(table)
      @table = table
    end

    def parse_zse
      tbody = table.find_element(:tag_name, 'tbody')
      rows = tbody.find_elements(:tag_name, 'tr')
      body_data = []
      puts "\nWriting body data"
      rows.each do |row|
        cells = row.find_elements(:tag_name, 'td')
        cells.each do |cell|
          body_data << cell.text.strip
        end
      end
      data = body_data.reject(&:empty?)
      header_data = data[1..4].map { |d| d.gsub("\n", " ") }
      remaining_data = data[5..]
      grouped_data = remaining_data.each_slice(4).to_a
      data = grouped_data.reject { |row| row.first.match?(/^[-+]?\d+(\.\d+)?$/) }
      data = data[0...-1]
      output = []
      data.each do |row|
        result = {}
        row.each_with_index do |value, index|
          result[header_data[index]] = value
        end
        output << result
        print "."
      end
      output
    end

    def parse
      header_data = []
      begin
        thead = table.find_element(:tag_name, "thead")
        cells = thead.find_element(:tag_name, "tr").find_elements(:tag_name, 'th')
        puts "Writing header data"
        cells.each do |cell|
          header_data << cell.text
          print "."
        end
      rescue Selenium::WebDriver::Error::NoSuchElement => e
        # Handle missing header gracefully (e.g., log the error)
      end
      tbody = table.find_element(:tag_name, "tbody")
      rows = tbody.find_elements(:tag_name, 'tr')
      body_data = []
      puts "\nWriting body data"
      rows.each do |row|
        data = {}
        cells = row.find_elements(:tag_name, 'td')
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
