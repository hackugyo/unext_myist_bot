# coding: utf-8
require 'bundler'
Bundler.require
require 'http'
require 'json'
require './unext.rb'

puts ("processing...")
result = scrape
line = "\n"
week = result.week.join(line)
week = (week.length > 0 ? "今週が期限です\n#{week}" : "")
today = result.today.join(line)
today = (today.length > 0 ? "今日が期限です\n#{today}" : "")
if (week.length > 0 or today.length > 0) then
  response = HTTP.post('https://slack.com/api/chat.postMessage', params: {
                         token: ENV['HUBOT_SLACK_TOKEN'],
                         channel: '#general',
                         text: "#{week}\n#{today}",
                         as_user: true,
                       })
  puts JSON.pretty_generate(JSON.parse(response.body))
end
