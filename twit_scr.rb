require 'mechanize'
require 'net/http'
require 'json'
 
# Security Issue
EMAIL = "-----"
PASSWORD = "-----"
 
# get a vacant screen_name
suggestions_json = Net::HTTP.get(URI.parse('https://twitter.com/users/username_available?suggest=1'))
suggestions = JSON.parse(suggestions_json)['suggestions']
target_screen_name = suggestions[0]['suggestion']
 
agent = Mechanize.new
agent.get('https://mobile.twitter.com/login/error?redirect_after_login=settings%2Fscreen_name') do |login_page|
  change_page = login_page.form_with(action: '/sessions') { |form|
    form['session[username_or_email]'] = EMAIL
    form['session[password]'] = PASSWORD
  }.submit
  result_page = change_page.form_with(action: '/settings/screen_name') { |form|
    form['settings[screen_name]'] = target_screen_name
    form['settings[password]'] = PASSWORD
  }.submit
  if result_page.uri.to_s.include? 'screen_name'
    puts "Error: #{target_screen_name}"
  else
    puts "Success: #{target_screen_name}"
  end
end