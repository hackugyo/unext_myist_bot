# coding: utf-8
require 'bundler'
Bundler.require
require 'http'
require 'json'

response = HTTP.post("https://slack.com/api/api.test")
puts JSON.pretty_generate(JSON.parse(response.body))
