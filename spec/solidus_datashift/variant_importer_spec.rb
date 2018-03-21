# frozen_string_literal: true

require 'spec_helper'

describe SolidusDataShift::Importer::Variant do
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

    it 'should associate variant with product' do
      expect { importer.run }.to change { product.variants.count }.by(2)
    end

    it 'should store data price correctly' do
      importer.run
      variant = product.variants.find_by(sku: @variant_data[1])
      expect(variant.price.to_f).to eq(@variant_data[2].to_f)
    end

    it 'should populate stock item' do
      importer.run
      variant = product.variants.find_by(sku: @variant_data[1])
      expect(variant.stock_items.first.count_on_hand).to eq(@variant_data[3].to_i)
    end

    context 'with multiple stock locations' do
      let!(:stock_location) { create(:stock_location, name: 'CA Warehouse') }

      context 'with count_on_hand like integer' do
        it 'should populate stock item in all stock locations' do
          importer.run
          variant = product.variants.find_by(sku: @variant_data[1])
          expect(variant.stock_items.count).to eq(2)

          variant.stock_items.each do |stock_item|
            expect(stock_item.count_on_hand).to eq(@variant_data[3].to_i)
          end
        end
      end

      context 'with stock_locations list' do
        let(:stock_importer) { described_class.new(fixture_file('spree_variants_multiple_locations.csv')) }

        before do
          @variant_stock_data = CSV.read(fixture_file('spree_variants_multiple_locations.csv'))[1]
          master_sku = @variant_stock_data[0]
          product.master.update(sku: master_sku)
          stock_importer.run
        end

        it 'should associate variant with product' do
          expect(product.variants.count).to eq(2)
        end

        it 'should populate stock item accordingly' do
          variant = product.variants.find_by(sku: @variant_stock_data[1])
          ny_location = Spree::StockLocation.find_by(name: 'NY Warehouse')
          ny_item = Spree::StockItem.find_by(variant_id: variant.id, stock_location_id: ny_location.id)
          expect(ny_item.count_on_hand).to eq(5)

          ca_location = Spree::StockLocation.find_by(name: 'CA Warehouse')
          ca_item = Spree::StockItem.find_by(variant_id: variant.id, stock_location_id: ca_location.id)
          expect(ca_item.count_on_hand).to eq(15)
        end
      end
    end
  end
end
