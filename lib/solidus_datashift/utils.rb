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
      inventory = data.to_s.split('|')

      if inventory.size > 1
        inventory.each do |stock_hash|
          name, stock = stock_hash.split(':')
          stock_location = Spree::StockLocation.where('name LIKE ?', name)
            .first_or_create(name: name)
          populate_stock(stock_location, record, stock)
        end
      else
        Spree::StockLocation.all.each do |stock_location|
          populate_stock(stock_location, record, inventory.first)
        end
      end
    end

    def populate_stock(stock_location, variant, count)
      variant.save unless variant.persisted?
      stock_item = Spree::StockItem.find_or_create_by(
        stock_location_id: stock_location.id,
        variant_id: variant.id
      )
      stock_item.set_count_on_hand(count)
    end
  end
end
