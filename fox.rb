require 'nokogiri'
require 'open-uri'
require 'watir'
require 'csv'
require 'headless'

module Selenium
  module WebDriver
    module Remote
      module Http
        module DefaultExt
          def request(*args)
            tries ||= 3
            super
          rescue Net::ReadTimeout, Net::HTTPRequestTimeOut, Errno::ETIMEDOUT => ex
            puts "#{ex.class} detected, retrying operation"
            (tries -= 1).zero? ? raise : retry            
          end
        end
      end
    end
  end
end
Selenium::WebDriver::Remote::Http::Default.prepend(Selenium::WebDriver::Remote::Http::DefaultExt)

class Scraper

  attr_accessor :browser

  def initialize
    @browser = Watir::Browser.new :firefox, profile: 'default', headless: true
  end

  def end
    puts "-----------------END-----------------"
    @browser.close
  end


  def flat_scrape

    puts "----------START FLAT_SCRAPE----------"

    district_url = ["https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=327&district%5B10%5D=337&district%5B1%5D=328&district%5B2%5D=329&district%5B3%5D=330&district%5B4%5D=331&district%5B5%5D=332&district%5B6%5D=333&district%5B7%5D=334&district%5B8%5D=335&district%5B9%5D=336&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=338&district%5B1%5D=339&district%5B2%5D=340&district%5B3%5D=341&district%5B4%5D=342&district%5B5%5D=343&district%5B6%5D=344&district%5B7%5D=345&district%5B8%5D=346&district%5B9%5D=347&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=152&district%5B1%5D=153&district%5B2%5D=154&district%5B3%5D=355&district%5B4%5D=356&district%5B5%5D=357&district%5B6%5D=358&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=125&district%5B1%5D=126&district%5B2%5D=127&district%5B3%5D=128&district%5B4%5D=129&district%5B5%5D=130&district%5B6%5D=131&district%5B7%5D=132&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=112&district%5B10%5D=122&district%5B11%5D=123&district%5B12%5D=124&district%5B13%5D=348&district%5B14%5D=349&district%5B15%5D=350&district%5B1%5D=113&district%5B2%5D=114&district%5B3%5D=115&district%5B4%5D=116&district%5B5%5D=117&district%5B6%5D=118&district%5B7%5D=119&district%5B8%5D=120&district%5B9%5D=121&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=100&district%5B10%5D=110&district%5B11%5D=111&district%5B1%5D=101&district%5B2%5D=102&district%5B3%5D=103&district%5B4%5D=104&district%5B5%5D=105&district%5B6%5D=106&district%5B7%5D=107&district%5B8%5D=108&district%5B9%5D=109&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=23&district%5B10%5D=33&district%5B11%5D=34&district%5B12%5D=35&district%5B13%5D=36&district%5B14%5D=37&district%5B15%5D=38&district%5B1%5D=24&district%5B2%5D=25&district%5B3%5D=26&district%5B4%5D=27&district%5B5%5D=28&district%5B6%5D=29&district%5B7%5D=30&district%5B8%5D=31&district%5B9%5D=32&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=13&district%5B1%5D=14&district%5B2%5D=15&district%5B3%5D=16&district%5B4%5D=17&district%5B5%5D=18&district%5B6%5D=19&district%5B7%5D=20&district%5B8%5D=21&district%5B9%5D=22&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=84&district%5B10%5D=94&district%5B11%5D=95&district%5B12%5D=96&district%5B13%5D=97&district%5B14%5D=98&district%5B15%5D=99&district%5B1%5D=85&district%5B2%5D=86&district%5B3%5D=87&district%5B4%5D=88&district%5B5%5D=89&district%5B6%5D=90&district%5B7%5D=91&district%5B8%5D=92&district%5B9%5D=93&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=39&district%5B10%5D=49&district%5B11%5D=50&district%5B12%5D=51&district%5B13%5D=52&district%5B14%5D=53&district%5B15%5D=54&district%5B16%5D=55&district%5B1%5D=40&district%5B2%5D=41&district%5B3%5D=42&district%5B4%5D=43&district%5B5%5D=44&district%5B6%5D=45&district%5B7%5D=46&district%5B8%5D=47&district%5B9%5D=48&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=56&district%5B10%5D=66&district%5B11%5D=67&district%5B12%5D=68&district%5B13%5D=69&district%5B14%5D=70&district%5B15%5D=71&district%5B1%5D=57&district%5B2%5D=58&district%5B3%5D=59&district%5B4%5D=60&district%5B5%5D=61&district%5B6%5D=62&district%5B7%5D=63&district%5B8%5D=64&district%5B9%5D=65&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1",
                    "https://www.cian.ru/cat.php?deal_type=sale&district%5B0%5D=72&district%5B10%5D=82&district%5B11%5D=83&district%5B1%5D=73&district%5B2%5D=74&district%5B3%5D=75&district%5B4%5D=76&district%5B5%5D=77&district%5B6%5D=78&district%5B7%5D=79&district%5B8%5D=80&district%5B9%5D=81&engine_version=2&is_by_homeowner=1&offer_type=flat&room1=1&room2=1&room3=1&room4=1&room5=1&room6=1"]

    district_names = ['НАО', 'ТАО', 'ЗелАО', 'СЗАО', 'ЗАО', 'СЗАО', 'САО', 'ЦАО', 'ЮАО', 'СВАО', 'ВАО', 'ЮВАО']

    pages = (2..61).to_a

    district_url.each do |district|

      @browser.goto(district)

      count = 0
      begin
        doc = Nokogiri::HTML.parse(browser.html)
      rescue Errno::ECONNRESET => e
        count += 1
        retry unless count > 10
        puts "tried 10 times and couldn't get #{district}: #{e}"
      end

      @browser.execute_script("window.scrollBy(0,200)")
      sleep(20)
      while @browser.div(:class, "button--3JzvW").exists?
        @browser.div(:class, "button--3JzvW").click
      end

      CSV.open("file.csv", "a+") do |csv|
        pages.each do |page|

          sleep(5)
          
          @browser.buttons(:class, ['_2_I0uxAX1QTt_l4n _35LKst7i1uZi74JV _3Lpyrczb3U4kA1TV button--2C5U- simplified-button--i5Y-q']).each do |b|
            sleep(2)
            b.click
          end
          
          sleep(5)

          @browser.divs(:class, ['text--3FCIm simplified-text--26E8g']).each do |div|
            sleep(2)
            tels = p div.text
            csv << [tels]
          end

          if @browser.div(:class, 'container--1LvHI').a(:text, "#{page}").present?
            @browser.div(:class, 'container--1LvHI').a(:text, "#{page}").click!
          else
            @browser.close
            sleep(30)
            @browser = Watir::Browser.new :firefox, profile: 'default', headless: true
            break
          end
        end
      end

      puts "---------------NEXT_DISTRICT---------------"
      delay_time = rand(3)
      sleep(delay_time)  
    end
  end
end

scraper = Scraper.new
flat_tels = scraper.flat_scrape
scraper.end


