require_relative '../page_objects/filter_page.rb'
require_relative '../page_objects/company_details_page.rb'
require_relative '../services/export_manager_service.rb'

require_relative '../exceptions/custom_exceptions.rb'


class YCCompanyDataScraperService
  include CustomExceptions

  def initialize(filters)
    @filters = filters
    @logger = Logger.new($stdout)
    @browser = Watir::Browser.new :chrome, options: {
      args: [
        '--headless',
        '--window-size=1920,1080',
        '--no-sandbox',
        '--disable-gpu',
        '--disable-dev-shm-usage'
      ]
    }
    @filter_page = FilterPage.new(@filters, @browser)
    @skipped_filters = []
    @company_data = []
  end

  def run
    begin
      @logger.info("Scraping started...")
      @skipped_filters = @filter_page.apply_filters
      @company_data = CompanyDetailsPage.new(@browser, @filters).scrape_company_details
      finalize_scrape
      @logger.info("Scraping completed successfully.")
    rescue ActionMethodError => e
      @logger.error("Failed to apply filter: #{e.message}")
      return
    rescue StandardError => e
      @logger.error("Something went wrong!: #{e.message}")
      return
    ensure
      @browser.close
    end
  end

  private

  def finalize_scrape
    file_name = "yc_public_companies_data"

    if @skipped_filters.any?
      @logger.warn("Some filters were skipped during the scraping process:")

      @skipped_filters.each do |skipped|
        @logger.warn("#{skipped[:filter]} was skipped because: #{skipped[:reason]}")
      end
    end

    csv_headers = ['Company Name', 'Location', 'Description', 'Batch', 'Company URL', 'Website', 'Founder Details']

    ExportManagerService.export_to_csv(@company_data, file_name, csv_headers) do |company|
      founder_details = company[:company_details][:founders].map do |founder|
        {
          name: founder[:name],
          role: founder[:role],
          biography: founder[:biography],
          twitter: founder[:twitter],
          linkedin: founder[:linkedin]
        }
      end

      [
        company[:company_name],
        company[:company_location],
        company[:short_description],
        company[:batch],
        company[:company_url],
        company[:company_details][:website],
        JSON.generate(founder_details)  # JSON encode the founder details
      ]
    end
  end
end
