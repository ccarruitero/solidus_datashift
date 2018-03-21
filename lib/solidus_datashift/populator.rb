# frozen_string_literal: true

require_relative './utils'

module SolidusDataShift
  class Populator < DataShift::Populator
    include SolidusDataShift::Utils
  end
end
