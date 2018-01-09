module Bittrex
  class Transaction
    include Helpers

    attr_reader :market, :quantity, :rate, :raw

    def initialize(attrs = {})
      @market = attrs['Market']
      @quantity = attrs['Quantity']
      @rate = attrs['Rate']
      @raw = attrs
    end

    def self.buy(market,quantity,rate)
      client.get('market/buylimit',{
        market: market,
        quantity: quantity,
        rate: rate,
      })
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end