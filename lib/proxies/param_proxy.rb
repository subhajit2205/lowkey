# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ParamProxy < Proxy
    attr_reader :expression, :name, :type, :position

    # TODO: Refactor file path, start line and scope into "meta scope" model.
    def initialize(expression:, name:, type:, file_path:, start_line:, scope:, position: nil) # rubocop:disable Metrics/ParameterLists
      super(file_path:, start_line:, scope:)

      @expression = expression
      @name = name
      @type = type
      @position = position
    end

    def required?
      @expression.required?
    end
  end
end
