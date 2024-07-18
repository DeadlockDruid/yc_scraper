class CompanyDetailsPage
  BASE_URL = 'https://ycombinator.com'
  INITIALLY_LISTED_COMPANIES_COUNT = 40
  COMPANIES_PER_PAGE = 20

  def initialize(browser, filters)
    @logger = Logger.new($stdout)
    @browser = browser
    @number_of_companies = filters['number_of_companies']
    @filters = filters['filters']
    @scraped_companies = []
  end

  def scrape_company_details
    fetch_companies
    fetch_company_details
    @scraped_companies
  end

  private

  def fetch_companies
    if @number_of_companies > INITIALLY_LISTED_COMPANIES_COUNT
      @remaining_companies = @number_of_companies - INITIALLY_LISTED_COMPANIES_COUNT
      number_of_scrolls = (@remaining_companies / COMPANIES_PER_PAGE).ceil + 1
      number_of_scrolls.times { scroll_to_load_more }
    end

    @scraped_companies = fetch_company_list
  end

  def fetch_company_list
    html = @browser.html
    doc = Nokogiri::HTML(html)
  
    companies_list_xpath = "//div[contains(@class, '_sharedDirectory_')]//div[contains(@class, '_rightCol_')]//a[contains(@class, '_company_')]"
    company_links = doc.xpath(companies_list_xpath)
  
    if company_links.empty?
      @logger.info("No companies found with applied filters")
      
      return []
    end
  
    company_links.map do |company_link|
      {
        company_name: company_link.at_css("span[class*='_coName_']").text.strip,
        company_location: company_link.at_css("span[class*='_coLocation_']").text.strip,
        short_description: company_link.at_css("span[class*='_coDescription_']").text.strip,
        batch: company_link.at_xpath(".//a[contains(@href, '?batch=')]").text.strip,
        company_url: "#{BASE_URL}#{company_link['href']}",
        company_details: {}
      }
    end
  end

  def fetch_company_details
    @scraped_companies.each do |company|
      company_details = get_individual_company_details(company[:company_url])
      company[:company_details].merge!(company_details)
    end
  end

  def get_individual_company_details(url)
    details = {
      website: nil,
      founders: []
    }

    doc = Nokogiri::HTML(URI.open(url))
    details[:website] = extract_website(doc)

    # Process different founder sections
    process_founder_section(doc, details, "//h3[contains(text(), 'Active Founders') or contains(text(), 'Former Founders')]/parent::*/following-sibling::div", true)
    process_founder_section(doc, details, "//div[contains(text(), 'Founders')]/following-sibling::div//div[@class='flex flex-row items-center gap-x-3']", false)

    details
  end

  def extract_website(doc)
    link_xpath = "//a[text()='Jobs']/parent::*/parent::*/following-sibling::*//a"
    link = doc.at_xpath(link_xpath)

    if link
      link['href'] unless link['href'].nil?
    end
  end

  def process_founder_section(doc, details, xpath, is_active)
    container = doc.at_xpath(xpath)
    return unless container

    container.children.each do |founder_div|
      details[:founders] << (is_active ? process_active_or_former_founder(founder_div) : process_standard_founder(founder_div))
    end
  end

  def process_active_or_former_founder(founder_div)
    {
      name: founder_div.at_css('h3').text.split(',', 2).first.strip,
      role: founder_div.at_css('h3').text.split(',', 2).last.strip,
      biography: founder_div.at_css('p').text.strip,
      twitter: extract_social_link(founder_div, 'twitter'),
      linkedin: extract_social_link(founder_div, 'linkedin')
    }
  end

  def process_standard_founder(founder_div)
    founder_div = founder_div.parent

    {
      name: founder_div.at_xpath(".//div[@class='font-bold']").text.strip,
      role: founder_div.xpath(".//div[@class='font-bold']/following-sibling::div").text.strip,
      biography: nil,
      twitter: extract_social_link(founder_div, 'twitter'),
      linkedin: extract_social_link(founder_div, 'linkedin')
    }
  end

  def extract_social_link(founder_div, network)
    link = founder_div.at_xpath(".//a[contains(@href, '#{network}')]")

    if link
      link['href'] unless link['href'].nil?
    end
  end

  def scroll_to_load_more
    @browser.scroll.to :bottom

    sleep 1
  end
end
