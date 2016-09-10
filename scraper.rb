
require 'curb'
require 'nokogiri'

http = Curl.get("http://www.detroitnews.com/") do |http|
  http.headers['User-Agent'] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36"
end

def extract_parts sections_html, css_name
  parts = []
  sections_html.css(css_name).each do |node|
    parts << {
      :title => node.css(".hgpm-list-hed").text,
      :description => node.css(".hgpm-back-listview-text").text
    }
  end
  parts
end

html = Nokogiri::HTML(http.body_str)
html.css(".detroitnews-headline-grid-primary").each do |node|
  sections_html = Nokogiri::HTML(node.inner_html)
  texts = extract_parts sections_html, ".hgpm-list-wrap"
  texts.each do |part|
    puts part.inspect, "\n\n"
  end
end