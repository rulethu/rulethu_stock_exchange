# frozen_string_literal: true
require 'selenium-webdriver'

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
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless")
      Selenium::WebDriver.for :chrome, options: options
    end
  end
end
