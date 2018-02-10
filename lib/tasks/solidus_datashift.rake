# frozen_string_literal: true

namespace :solidus_datashift do
  desc 'import product to Solidus'
  task :product_import, [:file] => :environment do |_t, args|
    SolidusDatashift::ProductImporter.new(args[:file]).run
  end
end
