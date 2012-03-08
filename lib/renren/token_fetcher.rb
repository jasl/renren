# -*- coding: utf-8 -*-
require 'uri'
require 'multi_json'
require 'net/http'
require 'digest'
require 'rest_client'

module Renren
  class TokenFetcher
    attr_accessor :refresh_token

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def get_token
      params = {}
      params[:grant_type] = 'refresh_token'
      params[:refresh_token] = @refresh_token
      params[:client_id] = Config.api_key
      params[:client_secret] = Config.api_secret
      uri = URI.parse('http://graph.renren.com/oauth/token')
      uri.query = URI.encode_www_form(params)
      res = MultiJson.decode(Net::HTTP.get(uri))
      if res['scope']
        res['access_token']
      else
        nil
      end
  end
end
