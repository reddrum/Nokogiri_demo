require 'rubygems'
require 'nokogiri'
require 'colored'
require 'mechanize'
 
query = 'ruby'
page_number = '2'
url = "http://www.amazon.com/s/field-keywords=#{query}?page=#{page_number}"
 
proxy_ip = 'xxx.xxx.xxx.xxx'
proxy_port = 'xxxx'
 
agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" } 
page = agent.get(url).body 
doc = Nokogiri::HTML(open(url))
 
doc.css('#resultsCol').css('.s-result-item').map do |el|
    # grab the title
    title = el.css('.s-access-title').text.strip    
    # grab the image
    image = el.css('.s-access-image')[0]['src']
    # grab the product link
    link = el.css('.s-access-detail-page')[0]['href']
    # grab the price of product
    price = el.css('.a-price').css('.a-offscreen')[0]
    price = price != nil ? price.text : '-'
 
    puts "#{title}".green
    puts "Image url:".yellow + " #{image}"
    puts "Amazon link:".yellow + " #{link}"
    puts "Price: #{price}".red
    puts ""
end