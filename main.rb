require 'json'
require 'watir'
require 'debug'
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'

require_relative 'services/yc_company_data_scraper_service'
require_relative 'config'


URL = "https://www.ycombinator.com/companies"


def load_filters
  filters_path = './filters.json'

  JSON.parse(File.read(filters_path))
end

def main
  filters = load_filters
  scraper = YCCompanyDataScraperService.new(filters)

  scraper.run
rescue StandardError => e
  puts "An error occurred: #{e.message}"
  puts e.backtrace
end

main if __FILE__ == $0
