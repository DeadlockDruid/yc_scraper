require 'selenium-webdriver'

# Set up paths for Selenium to find ChromeDriver and the Chrome binary
Selenium::WebDriver::Chrome.path = ENV.fetch('CHROME_BINARY_PATH', '/usr/bin/chromium')
Selenium::WebDriver::Chrome::Service.driver_path = ENV.fetch('CHROME_DRIVER_PATH', '/usr/bin/chromedriver')
