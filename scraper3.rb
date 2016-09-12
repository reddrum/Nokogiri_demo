require 'rubygems'
require 'nokogiri'
require 'open-uri'

@url = "https://hackerone.com"

def load_page(page)
  begin
    sleep(1)
    @page = Nokogiri::HTML(open(page))
    puts "Loaded #{page}"
  rescue SocketError => se
    puts "Socket Error: #{se}. Ending script."
    exit
  end
end