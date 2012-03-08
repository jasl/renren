# code is an adaptation of the twitter gem by John Nunemaker
# Copyright (c) 2009 Davidsun

require 'renren/config'
require 'renren/base'
require 'renren/token_fetcher'

if File.exists?('config/weibo.yml')
  weibo_oauth = YAML.load_file('config/weibo.yml')[Rails.env || env || 'development']
  Weibo::Config.api_key = weibo_oauth["api_key"]
  Weibo::Config.api_secret = weibo_oauth["api_secret"]
end
