
require 'curb'
require 'nokogiri'

http = Curl.get("http://www.interfax.ru/") do |http|
  http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
end

puts http.body_str

html