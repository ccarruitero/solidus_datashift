# frozen_string_literal: true

require 'solidus_datashift/importer'
require 'solidus_datashift/populator/product'

module SolidusDataShift
  class Importer::Product < Importer
    def inclusion_columns
      %w[ cost_price images price shipping_category sku stock_items variant_sku
          variant_cost_price variant_price variant_images count_on_hand]
    end

    def importer_model
      Spree::Product
    end

    def importer_populator
      Populator::Product
    end
  end
end
