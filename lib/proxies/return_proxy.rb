# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ReturnProxy < Proxy
    attr_reader :type_expression, :name

    def initialize(type_expression:, name:, file_path:, start_line:, scope:)
      super(file_path:, start_line:, scope:)

      @type_expression = type_expression
      @name = name
    end
  end
end
