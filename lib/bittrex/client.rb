require 'faraday'
require 'base64'
require 'json'

module Bittrex
  # class DoNotEncoder
  #   def self.encode(params)
  #     buffer = ''
  #     params.each do |key, value|
  #       buffer << "#{key}=#{value}&"
  #     end
  #   return buffer.chop
  #   end
  # end

  class Client
    HOST = 'https://bittrex.com/api/v1.1'
    # https://bittrex.com/api/v2.0/key/balance/getbalances

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      response = connection.get do |req|
        url = "#{HOST}/#{path}"
        req.params.merge!(params)
        req.url(url)

        if key
          req.params[:apikey]   = key
          req.params[:nonce]    = nonce
          req.headers[:apisign] = signature(url, nonce)
        end
      end

      puts response.body

      JSON.parse(response.body)['result']
    end

    def post(path, params = {}, headers = {})
      nonce = Time.now.to_i
      response = connection.post do |req|
        url = "#{HOST}/#{path}"
        req.params.merge!(params)
        req.url(url)

        if key
          req.params[:apikey]   = key
          req.params[:nonce]    = nonce
          req.headers[:apisign] = signature(url, nonce)
        end

        puts req
      end

      puts response.body

      JSON.parse(response.body)['result']
    end

    # def post(path, params = {}, headers = {})
    #   nonce = Time.now.to_i
    #   response = connection.post do |req|
    #     url = "#{HOST}/#{path}"
    #     req.params.merge!(params)
    #     req.url(url)

    #     new_url = url + '?'

    #     if key
    #       # url = url.m
    #       params.each do |key, val|
    #         new_url += key.to_s
    #         new_url += '='
    #         new_url += val.to_s
    #         new_url += '&' 
    #       end

    #       new_url = new_url[0..-2]

    #       new_url += "&apikey=#{key}&nonce=#{nonce}"

    #       req.params[:apikey]   = key
    #       req.params[:nonce]    = nonce
    #       # req.headers[:apisign] = signature(new_url, nonce)
    #       req.headers[:apisign] = signature_post(new_url, nonce)
    #     end

    #     puts new_url
    #     # puts url
    #     puts req

    #   end

    #   puts response.body

    #   # JSON.parse(response.body)['result']
    # end

    private

    # def signature_post(url, nonce)
    #   OpenSSL::HMAC.hexdigest('sha512', secret, url)
    # end

    def signature(url, nonce)
      # OpenSSL::HMAC.hexdigest('sha512', secret, url)
      OpenSSL::HMAC.hexdigest('sha512', secret, "#{url}?apikey=#{key}&nonce=#{nonce}")
    end

    def connection
      @connection ||= Faraday.new(:url => HOST) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
        # faraday.options.params_encoder = DoNotEncoder
      end
    end
  end


end
