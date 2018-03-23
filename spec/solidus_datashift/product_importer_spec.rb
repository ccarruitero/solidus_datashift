# frozen_string_literal: true

require 'spec_helper'

describe SolidusDataShift::Importer::Product do
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

      it 'has correct taxons' do
        expect(@product.taxons.count).to eq(2)
        expect(@product.taxons.pluck(:name)).to eq(['Paintings', 'WaterColour'])
      end

      xit 'has correct product properties' do
      end

      xit 'has correct variants' do
      end

      it 'has correct count_on_hand' do
        expect(Spree::StockLocation.count).to eq(3)
        first_location = Spree::StockLocation.first
        first_stock_item = @product.stock_items.first
        expect(first_stock_item.stock_location).to eq(first_location)
        expect(first_stock_item.count_on_hand).to eq(12)
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
