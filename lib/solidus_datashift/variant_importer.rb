# frozen_string_literal: true

require_relative 'variant_populator'

module SolidusDataShift
  class VariantImporter < Importer
    def inclusion_columns
      %w[product_sku price]
    end

    def importer_model
      Spree::Variant
    end

    def importer_populator
      VariantPopulator
    end
  end
end
