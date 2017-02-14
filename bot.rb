# coding: utf-8
require 'bundler'
Bundler.require
require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require './unext.rb'

response = HTTP.post("https://slack.com/api/rtm.start", params: {
                       token: ENV['HUBOT_SLACK_TOKEN']
                     })
websocket_url = JSON.parse(response.body)['url']

SLACKBOT_USER_ID = 'USLACKBOT'
SLACKBOT_KEYWORD = 'Reminder: unext.'
EM.run do
  ws = Faye::WebSocket::Client.new(websocket_url)
  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    # p [:message, JSON.parse(event.data)] 
    if (data['user'] == SLACKBOT_USER_ID and data['text'] == SLACKBOT_KEYWORD) then
      puts ("processing...")
      result = scrape
      line = "\n"
      week = result.week.join(line)
      week = (week.length > 0 ? "今週が期限です\n#{week}" : "")
      today = result.today.join(line)
      today = (today.length > 0 ? "今日が期限です\n#{today}" : "")
      if (week.length > 0 or today.length > 0) then
        ws.send({
                  type: 'message',
                  text: "#{week}\n#{today}",
                  channel: data['channel']
                }.to_json)
      end
    end
  end

  # 接続が切断した時の処理
  ws.on :close do |event|
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end

