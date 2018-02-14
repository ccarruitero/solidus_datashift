# frozen_string_literal: true

require 'spec_helper'

describe SolidusDataShift::VariantImporter do
  context 'with csv file' do
    let(:importer) { described_class.new(fixture_file('spree_variants.csv')) }
    let(:product) { create(:product) }

    before do
      master_sku = CSV.read(fixture_file('spree_variants.csv'))[1][0]
      product.master.update(sku: master_sku)
    end

    it 'should upload variants' do
      expect { importer.run }.to change { Spree::Variant.count }.by(2)
    end

    it 'should associate variant to product' do
      expect { importer.run }.to change { product.variants.count }.by(2)
    end
  end
end
