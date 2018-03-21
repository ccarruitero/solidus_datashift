# frozen_string_literal: true

require 'spec_helper'

describe SolidusDataShift::ProductImporter do
  context 'with csv file' do
    let(:importer) { described_class.new(fixture_file('spree_products.csv')) }

    it 'should successfull upload products' do
      expect { importer.run }.to change { Spree::Product.count }.by(3)
    end

    context 'after run importer' do
      before do
        importer.run
        @product = Spree::Product.first
      end

      it 'has correct name' do
        expect(@product.name).to eq('Demo Product for AR Loader')
      end

      it 'has correct sku' do
        expect(@product.sku).to eq('DEMO_001')
      end

      it 'has correct price' do
        expect(@product.price.to_s).to eq('399.99')
      end

      it 'has correct cost_price' do
        expect(@product.cost_price.to_s).to eq('320.0')
      end

      it 'has correct shipping_category' do
        expect(@product.shipping_category.name).to eq('small')
      end

      xit 'has correct taxons' do
      end

      xit 'has correct product properties' do
      end

      xit 'has correct variants' do
      end

      xit 'has correct count_on_hand' do
      end
    end
  end

  context 'with xls file' do
    let(:importer) { described_class.new(fixture_file('spree_products.xls')) }

    it 'should successfull upload products' do
      expect { importer.run }.to change { Spree::Product.count }.by(3)
    end
  end
end
