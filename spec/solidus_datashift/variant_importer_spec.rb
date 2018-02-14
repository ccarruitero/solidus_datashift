# frozen_string_literal: true

require 'spec_helper'

describe SolidusDataShift::VariantImporter do
  context 'with csv file' do
    let(:importer) { described_class.new(fixture_file('spree_variants.csv')) }
    let(:product) { create(:product) }

    before do
      @variant_data = CSV.read(fixture_file('spree_variants.csv'))[1]
      master_sku = @variant_data[0]
      product.master.update(sku: master_sku)
    end

    it 'should upload variants' do
      expect { importer.run }.to change { Spree::Variant.count }.by(2)
    end

    it 'should associate variant to product' do
      expect { importer.run }.to change { product.variants.count }.by(2)
    end

    it 'should store data price correctly' do
      importer.run
      variant = product.variants.find_by(sku: @variant_data[1])
      expect(variant.price.to_f).to eq(@variant_data[2].to_f)
    end
  end
end
