# frozen_string_literal: true

require_relative 'importer'

module SolidusDataShift
  class ProductImporter < Importer
    def inclusion_columns
      %w[ cost_price images price shipping_category sku stock_items variant_sku
          variant_cost_price variant_price variant_images]
    end

    def importer_model
      Spree::Product
    end
  end
end
