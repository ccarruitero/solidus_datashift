# frozen_string_literal: true

require 'datashift'

module SolidusDatashift
  class ProductImporter
    def initialize(file_name)
      @file_name = file_name
      @datashift_loader = DataShift::Loader::Factory.get_loader(file_name)
    end

    def inclusion_columns
      %w[ cost_price images price shipping_category sku stock_items variant_sku
          variant_cost_price variant_price variant_images]
    end

    def run
      DataShift::Configuration.call.force_inclusion_of_columns = inclusion_columns
      @datashift_loader.run(@file_name, Spree::Product)
    end
  end
end
