# frozen_string_literal: true

module Lowkey
  class Scope
    attr_reader :file_path, :scope
    attr_accessor :lines, :start_line, :end_line

    def initialize(file_path:, scope:, lines:, start_line:, end_line: nil)
      @file_path = file_path
      @scope = scope

      @start_line = start_line
      @end_line = end_line
      @lines = lines
    end
  end
end
