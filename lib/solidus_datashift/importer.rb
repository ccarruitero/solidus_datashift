# frozen_string_literal: true

module SolidusDataShift
  class Importer
    def initialize(file_name)
      # TODO: allow receive StringIO
      @file_name = file_name
      @datashift_loader = DataShift::Loader::Factory.get_loader(file_name)
    end

    def importer_populator; end

    def inclusion_columns; end

    def run
      DataShift::PopulatorFactory.global_populator_class = importer_populator if importer_populator
      DataShift::Configuration.call.force_inclusion_of_columns = inclusion_columns if inclusion_columns
      @datashift_loader.run(@file_name, importer_model)
    end
  end
end
