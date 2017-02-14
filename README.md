## How to use

```
$ source application.env # Make your own one
$ bundle install --path vendor/bundler
$ heroku login
$ heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git
$ git push heroku master
$ sh env.sh
$ heroku run bundle exec ruby bot.rb
```


