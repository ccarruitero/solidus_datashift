# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Variant < Populator
    def prepare_and_assign_method_binding(method_binding, record, data)
      prepare_data(method_binding, data)
      if method_binding.operator?('product_sku')
        setup_product(method_binding, record, data)
      elsif method_binding.operator?('count_on_hand')
        setup_stock(record, data)
      else
        assign(method_binding, record)
      end
    end

    private

    def setup_product(method_binding, record, data)
      return unless method_binding.operator?('product_sku') && data.present?

      master = Spree::Variant.find_by(sku: data)
      record.product = master.product
    end

    def populate_stock(stock_location, variant, count)
      variant.save unless variant.persisted?
      stock_item = Spree::StockItem.find_by(stock_location_id: stock_location.id,
                                            variant_id: variant.id)
      stock_item.set_count_on_hand(count)
    end
  end
end
