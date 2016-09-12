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

file = open("hackerone_reports", "a+")
begin
  last_report = file.readline.match(/reports\/(\d+)/)[1].to_i
rescue EOFError
  last_report = 0
end

load_page("#{@url}/hacktivity")
count = 0

