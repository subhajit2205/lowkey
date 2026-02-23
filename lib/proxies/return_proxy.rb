# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class ReturnProxy < Proxy
    attr_reader :name
    attr_accessor :expression

    def initialize(file_path:, start_line:, scope:, name:)
      super(file_path:, start_line:, scope:)

      @name = name
      @expression = nil
    end
  end
end
