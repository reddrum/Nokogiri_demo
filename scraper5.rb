require 'nokogiri'
require 'open-uri'

url = "https://newyork.craigslist.org/search/cpg?query=developer&is_paid=all"

document = open(url)
content = document.read
parsed_content = Nokogiri::HTML(content)

parsed_content.css('.content').css('.row').each do |row|
  title       = row.css('.hdrlnk').inner_text
  posted_at   = row.css('time').first.attributes["datetime"].value
  neighb_elem = row.css('.pnr').css('small')

  if neighb_elem.any?
    neighborhood = neighb_elem.first.inner_text
  else
    neighborhood = ''
  end

  puts "#{title} #{neighborhood}"
  puts "Posted at #{posted_at}"
  puts '-------------------------------------------'
end
