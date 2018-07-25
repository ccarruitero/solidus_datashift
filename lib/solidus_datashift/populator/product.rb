# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Product < Populator
    def prepare_and_assign_method_binding(method_binding, record, data, opts)
      prepare_data(method_binding, data)
      if method_binding.operator?('sku')
        setup_product(method_binding, record, data, opts)
      elsif method_binding.operator?('count_on_hand')
        setup_stock(record, data)
      elsif method_binding.operator?('product_properties')
        setup_product_properties(record, data)
      elsif method_binding.operator?('taxons')
        setup_taxons(record, data)
      elsif method_binding.operator?('stores')
        setup_stores(record, data)
      elsif method_binding.operator?('option_types')
        setup_option_types(record, data)
      elsif method_binding.operator?('images')
        setup_images(record.master, data)
      else
        assign(method_binding, record)
      end
    end

    private

    # Expect taxon's names separated by `|`. Also, could define taxon's childs
    # separeted by `>`.
    # Ex: name|other_name>child>child|an_other_name
    def setup_taxons(record, data)
      taxon_list = split_data(data)

      taxon_list.each do |taxon_str|
        taxon_names = taxon_str.split(/\s*>\s*/)
        taxonomy = Spree::Taxonomy.find_or_create_by(name: taxon_names.shift)
        parent = taxonomy.root
        associate(record, 'taxons', parent)

        taxon_names.each do |taxon_name|
          taxon = Spree::Taxon.find_or_create_by(name: taxon_name,
                                                 taxonomy: taxonomy,
                                                 parent: parent)
          associate(record, 'taxons', taxon)
          parent = taxon
        end
      end
    end

    def setup_stores(record, data)
      if record.respond_to?('stores')
        store_names = split_data(data)
        store_names.each do |store_name|
          store = Spree::Store.find_or_create_by(name: store_name) do |obj|
            obj.code = store_name
            obj.url = "#{store_name}.example.com"
            obj.mail_from_address = 'mail@example.com'
          end

          associate(record, 'stores', store)
        end
      end
    end

    def setup_product_properties(record, data)
      properties_list = split_data(data)

      properties_list.each do |property_pair|
        name, value = property_pair.split(':')
        property = Spree::Property.find_or_create_by(name: name) do |obj|
          obj.presentation = name
        end

        product_property = Spree::ProductProperty.find_or_create_by(value: value) do |obj|
          obj.property = property
          obj.value = value
        end

        associate(record, 'product_properties', product_property)
      end
    end

    def setup_option_types(record, data)
      setup_options(data) do |option_type, _option_value|
        associate(record, 'option_types', option_type)
      end
    end

    def setup_product(method_binding, record, data, opts)
      variant = Spree::Variant.find_by(sku: data)

      if variant
        context = opts[:doc_context]
        context.reset(variant.product)
      else
        assign(method_binding, record)
      end
    end
  end
end
