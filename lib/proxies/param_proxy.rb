# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ParamProxy < Proxy
    attr_reader :name, :type, :position
    attr_accessor :expression

    # TODO: Refactor file path, start line and scope into "scope" model.
    def initialize(file_path:, start_line:, scope:, name:, type:, position: nil) # rubocop:disable Metrics/ParameterLists
      super(file_path:, start_line:, scope:)

      @name = name
      @type = type
      @position = position

      @expression = nil
    end

    def required?
      @expression.required?
    end
  end
end
