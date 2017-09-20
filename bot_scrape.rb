require 'telegram/bot'
require 'uri'
require 'HTTParty'
require 'Nokogiri'
 
token = '----------'
 
class Parser
    def self.parse_9gag page
        page.css('source')
    end
 
    def self.parse_tumblr page
        page.xpath('//*[@property="og:image"]')
    end
 
    def self.get_host url
      url = "http://#{url}" if URI.parse(url).scheme.nil?
      host = URI.parse(url).host.downcase
      host.start_with?('www.') ? host[4..-1] : host
    end
end
     
Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
        case message.text
        when '/start'
            bot.api.send_message(chat_id: message.chat.id, text: "Hi, #{message.from.first_name}. Please, send me the url you want to scrap.")
        when URI::regexp
            page = HTTParty.get(message.text)
            html = Nokogiri::HTML(page)
            host = Parser.get_host(message.text)
 
            case host
            when '9gag.com'
                items = Parser.parse_9gag(html)
            when 'tumblr.com'
                items = Parser.parse_tumblr(html)
            else
                items = []
            end
             
            if items.length == 0
                bot.api.send_message(chat_id: message.chat.id, text: "Sorry no gifs found :-(")
            else
                items.each { |x| 
                    link = x['src'] || x['content']
                    bot.api.send_message(chat_id: message.chat.id, text: "Here is your link: #{link}")
                }
            end
        else
            bot.api.send_message(chat_id: message.chat.id, text: "Invalid URL. Try again.")
        end
    end
end