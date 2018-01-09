module Bittrex
  class Transaction
    include Helpers

    attr_reader :market, :quantity, :rate, :raw

    def initialize(attrs = {})
      # @uuid = attrs['uuid']
      # @id = attrs['Uuid'].to_s
      @market = attrs['Market']
      @quantity = attrs['Quantity']
      @rate = attrs['Rate']
      @raw = attrs
    end

    # https://github.com/ericsomdahl/python-bittrex/issues/35
    def buy
      client.get('market/buylimit')
    end

    # def self.sell(market,quantity,rate)
    #   # client.get('market/selllimit').map{|data| new(data) }
    #   client.get('market/selllimit', {market: market, quantity: quantity, rate: rate})
    # end

    # def self.cancel_order(uuid)
    #   client.get('market/cancel', {uuid: uuid})
    # end

    # def self.get_order(uuid)
    #   client.get('account/getorder', {uuid: uuid})
    # end


    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end