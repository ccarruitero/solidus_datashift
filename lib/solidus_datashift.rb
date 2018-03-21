# frozen_string_literal: true

require 'solidus_core'
require 'datashift'
require 'solidus_datashift/engine'

Dir[File.join(File.dirname(__FILE__), 'solidus_datashift/importer/*.rb')].each { |f| require f }
