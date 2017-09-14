require 'ruby-instagram-scraper'
 
USERNAME = 'kranz42'
 
offset = nil
media_nodes = RubyInstagramScraper.get_user_media_nodes(USERNAME)
 
while !media_nodes.empty?
  media_nodes.each do |node|
    image_url = node['display_src']
    file_name = image_url.split('/').last
 
    unless File.exists?(file_name)
      puts "Downloading #{file_name}..."
      IO.copy_stream(open(image_url), file_name)
    else
      puts "#{file_name} already exists"
    end
  end
 
  offset = media_nodes.last['id']
  media_nodes = RubyInstagramScraper.get_user_media_nodes(USERNAME, offset)# rescue []
end