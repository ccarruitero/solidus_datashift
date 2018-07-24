# frozen_string_literal: true

require 'solidus_datashift/utils'

module SolidusDataShift
  class Populator < DataShift::Populator
    include SolidusDataShift::Utils

    def prepare_and_assign(context, record, data)
      prepare_and_assign_method_binding(
        context.method_binding,
        record,
        data,
        doc_context: context.doc_context
      )
    end
  end
end
