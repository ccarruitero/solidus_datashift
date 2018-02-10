# frozen_string_literal: true

require 'spec_helper'

describe SolidusDatashift::ProductImporter do
  context 'with csv file' do
    let(:importer) { described_class.new(fixture_file('spree_products.csv')) }

    it 'should successfull upload products' do
      expect { importer.run }.to change { Spree::Product.count }.by(3)
    end
  end

  context 'with xlc file' do
    let(:importer) { described_class.new(fixture_file('spree_products.xls')) }

    it 'should successfull upload products' do
      expect { importer.run }.to change { Spree::Product.count }.by(3)
    end
  end
end
