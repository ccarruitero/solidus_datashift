# frozen_string_literal: true

module SolidusDataShift
  module Utils
    # for count_on_hand we expect two kind of values:
    # * An integer (Ex: 30)
    #   In this case all stock locations are populated with the received value
    #
    # * A list of stock locations with stock values
    #   (Ex: foo_warehouse:20|bar_warehouse:10)
    #   In this case we attempt to find a stock location by name and populate
    #   with the asociated value
    def setup_stock(record, data)
      inventory = data.split('|')

      if inventory.size > 1
        inventory.each do |stock_hash|
          name, stock = stock_hash.split(':')
          stock_location = Spree::StockLocation.find_by('name LIKE ?', name)
          populate_stock(stock_location, record, stock)
        end
      else
        Spree::StockLocation.all.each do |stock_location|
          populate_stock(stock_location, record, inventory.first)
        end
      end
    end
  end
end
