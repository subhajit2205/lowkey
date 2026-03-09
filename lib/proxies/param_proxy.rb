# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ParamProxy < Proxy
    attr_reader :type, :position, :value
    attr_accessor :expression

    def initialize(name:, scope:, type:, position: nil, value: :LOWKEY_UNDEFINED, expression: nil) # rubocop:disable Metrics/ParameterLists
      super(name:, scope:)

      @type = type
      @position = position
      @value = value

      @expression = expression
    end

    def required?
      @value == :LOWKEY_UNDEFINED
    end
  end
end
