require 'nokogiri'
require 'open-uri'

nums = (1..23).to_a

nums.each do |num|
  url = "http://realty.dmir.ru/msk/agents/?skill=711&page=#{num}"

  document = open(url)
  content = document.read
  parsed_content = Nokogiri::HTML(content)

  name = parsed_content.at_css('.name-').text
  phone = parsed_content.at_css('.bold.mt15').text

  CSV.open('data-dmr', 'w') do |csv|
    csv << [name, phone]
  end

  delay_time = rand(3)
  sleep(delay_time)
  puts name + ' was added'
end

