require 'nokogiri'
require 'open-uri'

url = "https://newyork.craigslist.org/search/cpg?query=developer&is_paid=all"

document = open(url)
content = document.read

puts content