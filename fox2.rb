require 'nokogiri'
require 'open-uri'
require 'watir'
require 'csv'
require 'headless'

headless = Headless.new
headless.start

browser = Watir::Browser.new(:chrome, switches: %w(--no-sandbox))

nums = (1..30).to_a

pages = (1..3).to_a

pages.each do |page|
  url = "https://www.cian.ru/cat.php?deal_type=sale&engine_version=2&offer_type=flat&p=#{page}&region=1&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1&room7=1&room9=1"

  browser.goto(url)

  browser.element(:text, "Таблица").click

  doc = Nokogiri::HTML.parse(browser.html)

  CSV.open("file.csv", "a+") do |csv|
    nums.each do |num|
      if browser.table(:class, "objects_items_list")[num][8].exists?
        puts "#{browser.table(:class, "objects_items_list")[num][7].text}"
        delay_time = rand(2)
        sleep(delay_time)
      else
        next
      end
      csv << [browser.table(:class, "objects_items_list")[num][7].text]
    end
  end
  delay_time = rand(3)
  sleep(delay_time)  
end

browser.close
headless.destroy


CSV.parse("file.csv").delete_if { |row| row.include? "Заказать звонок" }