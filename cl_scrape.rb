require "selenium-webdriver"
require "csv"
test = Selenium::WebDriver.for :firefox
 
test.navigate.to "https://hamburg.craigslist.de/search/apa?min_bedrooms=1&max_bedrooms=3&min_bathrooms=1&max_bathrooms=2&availabilityMode=0"
 
crawled= test.find_elements(class: 'result-row')
 
 
titles = ['title', 'rent', 'url']
#
#
CSV.open("file.csv", "a+", :headers => :first_row) do |file|
  file << ["title", "rent", "url"]
  for home in crawled
     file << [home.find_element(class: 'result-title').text, home.find_element(class: 'result-price').text, home.find_element(css: 'a').attribute('href')]
   end
end
test.quit