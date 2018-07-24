# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Variant < Populator
    def prepare_and_assign_method_binding(method_binding, record, data, opts)
      prepare_data(method_binding, data)
      if method_binding.operator?('product_sku')
        setup_product(method_binding, record, data)
      elsif method_binding.operator?('sku', data)
        setup_variant(record, data, opts)
      elsif method_binding.operator?('count_on_hand')
        setup_stock(record, data)
      elsif method_binding.operator?('images')
        setup_images(record, data)
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

    def setup_variant(record, data, opts)
      context = opts[:doc_context]
      new_record = Spree::Variant.find_or_create_by(sku: data) do |obj|
        obj.product = record.product
      end
      context.reset(new_record)
    end
  end
end
