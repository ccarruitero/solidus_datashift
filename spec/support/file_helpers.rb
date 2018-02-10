# frozen_string_literal: true

module FileHelpers
  def fixture_file(name)
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end
end
