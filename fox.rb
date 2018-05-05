require 'nokogiri'
require 'open-uri'
require 'watir'
require 'csv'
require 'headless'

headless = Headless.new
headless.start

browser = Watir::Browser.new(:chrome, switches: %w(--no-sandbox))

# nums = (1..30).to_a

district_url = ["https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=327&district%5B10%5D=337&district%5B1%5D=328&district%5B2%5D=329&district%5B3%5D=330&district%5B4%5D=331&district%5B5%5D=332&district%5B6%5D=333&district%5B7%5D=334&district%5B8%5D=335&district%5B9%5D=336&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=338&district%5B1%5D=339&district%5B2%5D=340&district%5B3%5D=341&district%5B4%5D=342&district%5B5%5D=343&district%5B6%5D=344&district%5B7%5D=345&district%5B8%5D=346&district%5B9%5D=347&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1"]

district_names = ['НАО', 'ТАО', 'ЗелАО', 'СЗАО', 'ЗАО', 'СЗАО', 'САО', 'ЦАО', 'ЮАО', 'СВАО', 'ВАО', 'ЮВАО']

pages = (1..2).to_a

district_url.each do |district|

  browser.goto(district)

  doc = Nokogiri::HTML.parse(browser.html)

  CSV.open("file.csv", "a+") do |csv|
    pages.each do |page|

      browser.buttons(:class => "_2_I0uxAX1QTt_l4n _35LKst7i1uZi74JV _3Lpyrczb3U4kA1TV button--2C5U- simplified-button--i5Y-q").each do |b|
        sleep(1)
        b.click
      end

      browser.divs(:class => "text--3FCIm simplified-text--26E8g").each do |div|
        sleep(1)
        tels = div.text
        csv << [tels]
      end

      browser.div(:class, 'container--1LvHI').a(:text, "#{page}").wait_until_present.click
    end
  end
  delay_time = rand(3)
  sleep(delay_time)  
end

browser.close
headless.destroy
