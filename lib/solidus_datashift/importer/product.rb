# frozen_string_literal: true

require 'solidus_datashift/importer'
require 'solidus_datashift/populator/product'

module SolidusDataShift
  class Importer::Product < Importer
    def inclusion_columns
      %w[ cost_price images price shipping_category sku stock_items
          count_on_hand taxons]
    end

    def importer_model
      Spree::Product
    end

    def importer_populator
      Populator::Product
    end
  end
end
