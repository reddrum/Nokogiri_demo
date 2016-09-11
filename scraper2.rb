require 'nokogiri'
require 'open-uri'

url = "http://www.last.fm/ru/events"

data = Nokogiri::HTML(open(url))

events = data.css(".events-list")

events.each do |event|

  puts event.css(".events-list-item-event--title").text

  puts event.css(".events-list-item-venue--title").text

  puts event.css(".events-list-item-venue--city").text

end