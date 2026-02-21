# frozen_string_literal: true

require_relative 'mock_module'

module Lowkey
  class ExtendModule
    extend MockModule

    method_one
  end
end
