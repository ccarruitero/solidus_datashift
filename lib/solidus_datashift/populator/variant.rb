# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Variant < Populator
    OPTIONS_ALIAS = %w[options option_types option_values]
    PROPERTIES_ALIAS = %w[variant_properties product_properties properties]

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
      elsif OPTIONS_ALIAS.include?(method_binding.operator)
        setup_variant_options(record, data)
      elsif PROPERTIES_ALIAS.include?(method_binding.operator)
        setup_variant_properties(record, data)
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

    def setup_variant_options(record, data)
      setup_options(data) do |_option_type, option_value|
        associate(record, 'option_values', option_value)
      end
    end

    # since variant is not directly associate with properties instead through
    # option_value, we need to pass the option_value and properties

    # The expected string in this case should be:
    # `option_type:option_value>property_name:property_value`
    # Ex: color:white>material:paper
    def setup_variant_properties(record, data)
      product = record.product
      group_list = split_data(data)

      group_list.each do |list|
        option_string, property_string = list.split('>')
        property_name, property_value = property_string.split(':')
        property = Spree::Property.find_or_create_by(name: property_name) do |obj|
          obj.presentation = property_name
        end

        setup_options(option_string) do |_option_type, option_value|
          property_rule = product.variant_property_rules
            .includes(:values, :conditions)
            .find_by(
              spree_variant_property_rule_values: {
                property_id: property.id, value: property_value
              },
              spree_variant_property_rule_conditions: {
                option_value_id: option_value.id
              }
            )

          unless property_rule
            rule = product.variant_property_rules.create
            rule.values.create(property: property, value: property_value)
            rule.conditions.create(option_value: option_value)
          end
        end
      end
    end
  end
end
