# frozen_string_literal: true

namespace :solidus_datashift do
  desc 'import product to Solidus'
  task :product_import, [:file] => :environment do |_t, args|
    SolidusDataShift::Importer::Product.new(args[:file]).run
  end

  desc 'import variants to Solidus'
  task :variant_import, [:file] => :environment do |_t, args|
    SolidusDataShift::Importer::Variant.new(args[:file]).run
  end
end
