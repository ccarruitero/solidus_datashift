# frozen_string_literal: true

require 'solidus_datashift/importer'
require 'solidus_datashift/populator/variant'

module SolidusDataShift
  class Importer::Variant < Importer
    def inclusion_columns
      %w[product_sku price count_on_hand options option_types]
    end

    def importer_model
      Spree::Variant
    end

    def importer_populator
      Populator::Variant
    end
  end
end
