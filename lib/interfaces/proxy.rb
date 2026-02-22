# frozen_string_literal: true

module Lowkey
  class Proxy
    attr_reader :file_path, :start_line, :scope

    def initialize(file_path:, start_line:, scope:)
      @file_path = file_path
      @start_line = start_line
      @scope = scope
    end
  end
end
