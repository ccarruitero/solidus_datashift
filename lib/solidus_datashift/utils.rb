# frozen_string_literal: true

require 'mechanize'

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
      inventory = split_data(data)

      if inventory.size > 1
        inventory.each do |stock_hash|
          name, stock = stock_hash.split(':')
          adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
          query_method = adapter == 'postgresql' ? 'ILIKE' : 'LIKE'
          query = "name #{query_method} ?"
          stock_location = Spree::StockLocation.where(query, name)
            .first_or_create(name: name)
          populate_stock(stock_location, record, stock)
        end
      else
        Spree::StockLocation.all.each do |stock_location|
          populate_stock(stock_location, record, inventory.first)
        end
      end
    end

    def setup_images(record, data)
      images = split_data(data)
      images.each do |image_url|
        agent = Mechanize.new
        image_file = agent.get(image_url)
        name, extension = image_file.filename.split('.')
        temp_file = Tempfile.new([name, ".#{extension}"], encoding: 'ascii-8bit')
        begin
          temp_file.write image_file.body
          temp_file.rewind
          image = Spree::Image.create(attachment: temp_file)
          record.images << image
        ensure
          temp_file.close
          temp_file.unlink
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

    def split_data(data)
      data.to_s.split('|')
    end

    def setup_options(data, &block)
      type_list = split_data(data)

      type_list.each do |type_str|
        name, values = type_str.split(':')
        option_type = Spree::OptionType.find_or_create_by(name: name) do |obj|
          obj.presentation = name
        end

        values.split(',').map(&:strip).each do |value|
          option_type.option_values.find_or_create_by(name: value) do |obj|
            obj.presentation = value
          end
        end

        yield(option_type)
      end
    end

    def associate(record, association_name, item)
      association = record.send(association_name)
      association << item unless association.include?(item)
    end
  end
end
