require 'nokogiri'
require 'open-uri'

cities = ['newyork', 'lasvegas']
search_terms = ['ruby', 'python']

cities.each do |city|
  search_terms.each do |search_term|

    url = "http://#{city}.craigslist.org/search/cpg?query=#{search_term}&is_paid=all"

    document = open(url)
    content = document.read
    parsed_content = Nokogiri::HTML(content)

    puts '============================================='
    puts '-                                           -'
    puts "-          #{city} - #{search_term}          "
    puts '-                                           -'
    puts '============================================='

    parsed_content.css('.content').css('.row').each do |row|
      title       = row.css('.hdrlnk').first.inner_text
      link        = row.css('.hdrlnk').first.attributes["href"].value
      posted_at   = row.css('time').first.attributes["datetime"].value
      neighb_elem = row.css('.pnr').css('small')

      if neighb_elem.any?
        neighborhood = neighb_elem.first.inner_text.strip
      else
        neighborhood = ''
      end

      puts "#{title} #{neighborhood}"
      puts "Link: #{link}"
      puts "Posted at #{posted_at}"
      puts '-------------------------------------------'
    end
  end
end

