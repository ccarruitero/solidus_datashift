# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Product < Populator
    def prepare_and_assign_method_binding(method_binding, record, data)
      prepare_data(method_binding, data)
      if method_binding.operator?('count_on_hand')
        setup_stock(record, data)
      elsif method_binding.operator?('taxons')
        setup_taxons(record, data)
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
        add_taxon_to_product(record, parent)

        taxon_names.each do |taxon_name|
          taxon = Spree::Taxon.find_or_create_by(name: taxon_name,
                                                 taxonomy: taxonomy,
                                                 parent: parent)
          add_taxon_to_product(record, taxon)
          parent = taxon
        end
      end
    end

    def add_taxon_to_product(product, taxon)
      product.taxons << taxon unless product.taxons.include?(taxon)
    end
  end
end
