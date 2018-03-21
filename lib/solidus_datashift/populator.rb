# frozen_string_literal: true

require 'solidus_datashift/utils'

module SolidusDataShift
  class Populator < DataShift::Populator
    include SolidusDataShift::Utils
  end
end
