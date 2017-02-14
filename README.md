## How to use

```
$ source application.env # Make your own one
$ bundle install --path vendor/bundler
$ heroku login
$ heroku create
$ heroku config:add BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-multi.git
$ git push heroku master
$ sh env.sh
$ heroku run bundle exec ruby bot.rb # 実行すると待ち受け体勢に入る
```


