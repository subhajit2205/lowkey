# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ReturnProxy < Proxy
    attr_reader :name, :value
    attr_accessor :expression

    def initialize(file_path:, start_line:, scope:, name:, value: :LOWKEY_UNDEFINED, expression: nil) # rubocop:disable Metrics/ParameterLists
      super(file_path:, start_line:, scope:)

      @name = name
      @value = value
      @expression = expression
    end
  end
end
