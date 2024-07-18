require 'selenium-webdriver'

# Set up paths for Selenium to find ChromeDriver and the Chrome binary
Selenium::WebDriver::Chrome.path = ENV['CHROME_BINARY_PATH']
Selenium::WebDriver::Chrome::Service.driver_path = ENV['CHROME_DRIVER_PATH']
