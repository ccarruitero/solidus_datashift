# frozen_string_literal: true

require 'solidus_datashift/populator'

module SolidusDataShift
  class Populator::Product < Populator
    def prepare_and_assign_method_binding(method_binding, record, data)
      prepare_data(method_binding, data)
      if method_binding.operator?('count_on_hand')
        setup_stock(record, data)
      else
        assign(method_binding, record)
      end
    end
  end
end
