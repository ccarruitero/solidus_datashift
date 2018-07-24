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
        expect(@product.taxons.pluck(:name)).to include('Paintings')
        expect(@product.taxons.pluck(:name)).to include('WaterColour')
      end

      it 'has correct product properties' do
        expect(@product.product_properties.count).to eq(1)
        product_property = @product.product_properties.first
        expect(product_property.property.name).to eq('test')
        expect(product_property.value).to eq('pp_001')
      end

      it 'has correct option types' do
        expect(@product.option_types.count).to eq(1)

        option_type = @product.option_types.first
        expect(option_type.option_values.count).to eq(3)
      end

      it 'has correct count_on_hand' do
        expect(Spree::StockLocation.count).to eq(3)
        first_location = Spree::StockLocation.first
        first_stock_item = @product.stock_items.first
        expect(first_stock_item.stock_location).to eq(first_location)
        expect(first_stock_item.count_on_hand).to eq(12)
      end

      it 'has correct available_on' do
        expect(@product.available_on.to_date).to eq(Date.parse('2011-02-14'))
      end

      it 'allow associate stores to product' do
        expect(@product.stores.count).to eq(1) if @product.respond_to?('stores')
      end

      it 'allow image' do
        expect(@product.images.count).to eq(1)
      end
    end
  end

  context 'with spanish characters' do
    let(:importer) { described_class.new(fixture_file('products_spanish.csv')) }
    let(:subject) { importer.run }

    it 'should successfull upload products' do
      expect { subject }.to change { Spree::Product.count }.by(2)
    end

    it 'save name correctly' do
      subject
      product0 = Spree::Product.first
      expect(product0.name).to eq('Almohadón')

      product1 = Spree::Product.last
      expect(product1.name).to eq('Cañón')
    end
  end

  context 'with an exiting product' do
    let(:importer) { described_class.new(fixture_file('spree_products.csv')) }
    let(:update) { described_class.new(fixture_file('update_product.csv')) }

    before do
      importer.run
      update.run
    end

    it 'success update product' do
      product = Spree::Product.first
      expect(product.name).to eq('Alternative name')
    end
  end

  context 'with xls file' do
    let(:importer) { described_class.new(fixture_file('spree_products.xls')) }

    it 'should successfull upload products' do
      expect { importer.run }.to change { Spree::Product.count }.by(3)
    end
  end
end
