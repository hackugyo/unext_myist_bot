# coding: utf-8
require 'bundler'
Bundler.require
require 'capybara/poltergeist'

def normalize(date_text)
  meaningful = date_text.split('日')[0]
  regex = /[一-龠]+/
  year, month, day = meaningful.split(regex)
  format("%04d", year) + format("%02d", month) + format("%02d", day)
end

class Result
  def initialize(movies)
    @movies = movies
  end

  def week
    limit(Date.today, lambda {|p, q| (p - q).to_int == 7})
  end
  
  def today
    limit(Date.today)
  end

  def limit(day, proc = lambda {|p, q| (p - q).to_int == 0})
    @movies.select { |m|
      proc.call(DateTime.parse(m.limit), day)
    }.map { |m| "#{m.limit},\"#{m.title}\",#{m.price},#{m.url}" }
  end
end

Movie = Struct.new(:url, :title, :limit, :price)

def scrape
  target_url = "http://video.unext.jp/mylist/favorite"

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
end
  Capybara.default_selector = :xpath # :css -> :xpath
  session = Capybara::Session.new(:poltergeist)
  session.driver.headers = { 'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
  
  session.visit target_url
  
  # ログイン
  email_input = session.find("/html/body/div[1]/div/div/div/div[1]/form/div[1]/label[1]/input")
  email_input.native.send_key(ENV['UNEXT_ID'])
  
  password_input = session.find("/html/body/div[1]/div/div/div/div[1]/form/div[1]/label[2]/input")
  password_input.native.send_key(ENV['UNEXT_PASSWORD'])

  Capybara.default_selector = :css
  login_button = session.find(".js-acc-login-btn--submit")
  login_button.click
  
  # 一覧を最後まで取得する
  initial_count = session.all(".ui-item-v__link").count
  while true do
    session.execute_script "window.scrollBy(0,10000)"
    sleep 3
    current_count = session.all(".ui-item-v__link").count
    if (initial_count == current_count) then
      break
    else
      initial_count = current_count
    end
  end
  
  # 配信期限を取得する
  links = session.all(".ui-item-v__link")
  
  results = []
  agent = Mechanize.new
  links.each.with_index do |link, i|
    agent.get(link[:href]) do |page|
      title = page.search('/html/body/div[1]/div/div/div[3]/div/div/div[1]/div[2]/h1').text
      limit = page.search('/html/body/div[1]/div/div/div[4]/div[2]/div/div[1]/span').text
      price = page.search('/html/body/div[1]/div/div/div[3]/div/div/div[1]/div[4]/div/span').text
      results << Movie.new(link[:href], title, normalize(limit), price)
    end
  end
  return Result.new(
           results
           .sort_by { |m| m.limit})
end

# result = scrape
# puts result.week.join("\n")
# puts result.today.join("\n")
