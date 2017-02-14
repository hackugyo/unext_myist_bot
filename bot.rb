# coding: utf-8
require 'bundler'
Bundler.require
require 'http'
require 'json'

response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
                       token: ENV['HUBOT_SLACK_TOKEN'],
                       channel: "#general",
                       text: "UNEXT ！",
                       as_user: true,
                     })
puts JSON.pretty_generate(JSON.parse(response.body))
