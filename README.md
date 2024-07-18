# Y Combinator Company Scraper

This Ruby application scrapes company information from Y Combinator's directory and exports the data to a CSV file. It utilizes Watir for web browsing and Nokogiri for HTML parsing.

## Features

- Scrape company names, locations, descriptions, and founder details.
- Apply filters dynamically based on user input.
- Export scraped data to a CSV file.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Ruby 3.3.4
- Bundler for managing Ruby gems
- Google Chrome and ChromeDriver installed on your machine
- Ensure that the environment variables for the Chrome binary and WebDriver are correctly set in the Dockerfile’s ENV section.


## Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/anshu1992/yc_scraper.git
cd yc_scraper
```

Install the required gems:

```bash
bundle install
```

## Configuration

To configure the scraper, modify the `filters.json` file in the project root to include the filters you want to apply. Example of filter settings:

```json
{
  "number_of_companies": 120,
  "filters": {
    "industry": ["Healthcare", "Fintech", "Consumer", "Industrials"],
    "region": ["America / Canada"],
    "company_size": "1-10",
    "is_hiring": true
  }
}
```

## Usage

Run the scraper using the following command:

```bash
ruby main.rb
```

This will initiate the scraping process based on the provided filters and export the data to a CSV file named `yc_public_companies_data.csv` in the project root directory.

## Docker Support

To run the scraper inside a Docker container, follow these steps:

1. Build the Docker image:

```bash
docker build -t yc_scraper .
```

2. Run the container:

```bash
docker run -it --name yc_scraper yc_scraper ruby main.rb
```

3. Export the CSV to your local directory

```bash
docker cp yc_scraper:/app/yc_public_companies_data.csv ./yc_public_companies_data.csv
```

This will execute the scraper within a Docker environment, using the settings defined in your local `filters.json`.
