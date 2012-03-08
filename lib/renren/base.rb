# -*- coding: utf-8 -*-
require 'uri'
require 'multi_json'
require 'net/http'
require 'digest'

module Renren
  class Base
    attr_accessor :params

    def initialize(access_token)
      @params = {}
      @params[:method] = "friends.get"
      @params[:call_id] = Time.now.to_i
      @params[:format] = 'json'
      @params[:v] = '1.0'
      @params[:access_token] = access_token
    end
    
    def call_method(opts = {:method => "users.getinfo"})
      MultiJson.decode(Net::HTTP.post_form(URI.parse('http://api.renren.com/restserver.do'), update_params(opts)).body)
    end
    
    private
      def update_params(opts)
        params = @params.merge(opts){|key, first, second| second}
        params[:sig] = Digest::MD5.hexdigest(params.map{|k,v| "#{k}=#{v}"}.sort.join + Config.api_secret)
        params
      end
  end

  class ByRefeshToken
    attr_accessor :params

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
