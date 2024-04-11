# frozen_string_literal: true
require "selenium-webdriver"

module RulethuStockExchange
  class Scraper
    def initialize(url)
      @url = url
      @driver = setup_driver
    end

    def scrape(selector)
      @driver.navigate.to(@url)
      sleep 5
      @driver.find_element :css, selector
    end

    private

    def setup_driver
      options = Selenium::WebDriver::Firefox::Options.new

      options.add_argument("--headless")
      options.add_argument("--disable-gpu")

      Selenium::WebDriver::Firefox.path = ENV["FIREFOX_BIN"] || `which firefox`
      Selenium::WebDriver::Firefox::Service.driver_path = ENV["GECKODRIVER_PATH"] || `which geckodriver`.strip

      # use argument `:debug` instead of `:info` for detailed logs in case of an error
      Selenium::WebDriver.logger.level = :info

      Selenium::WebDriver.for :firefox, options: options
    end
  end
end
