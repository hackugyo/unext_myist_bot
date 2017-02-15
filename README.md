## Deploy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## How to use

```
$ source application.env # Make your own one
$ bundle install --path vendor/bundler
$ heroku login
$ $ heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git
$ heroku buildpacks:add --index 1 https://github.com/stomita/heroku-buildpack-phantomjs
$ git push heroku master
$ sh env.sh
$ heroku addons:create scheduler:standard
$ heroku addons:open scheduler # bundle exec ruby bot.rb を設定
```
```
$ heroku logs --ps scheduler.1 # ログ確認
$ bundle exec ruby bot.rb # ローカルで実行
```


