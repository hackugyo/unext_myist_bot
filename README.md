## How to use

```
$ source application.env # Make your own one
$ bundle install --path vendor/bundler
$ heroku login
$ $ heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git
$ heroku buildpacks:add --index 1 https://github.com/stomita/heroku-buildpack-phantomjs
$ git push heroku master
$ sh env.sh
$ heroku run bundle exec ruby bot.rb # 実行すると待ち受け体勢に入る
```


