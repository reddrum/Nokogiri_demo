require 'mechanize'

agent = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

page = agent.get('https://wikipedia.org')

pp page