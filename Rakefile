# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require_relative "lib/rulethu_stock_exchange/driver"

Minitest::TestTask.create

require "standard/rake"

task default: %i[test standard]

task :download_driver do
  RulethuStockExchange::Driver.geckodriver
end
