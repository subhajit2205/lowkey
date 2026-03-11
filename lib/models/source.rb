# frozen_string_literal: true

module Lowkey
  class Source
    attr_reader :file_path, :scope
    attr_accessor :lines, :start_line, :end_line

    def initialize(file_path:, scope:, lines:, start_line:, end_line: nil)
      @file_path = file_path
      @scope = scope

      @start_line = start_line
      @end_line = end_line
      @lines = lines
    end

    def wrap(prefix:, suffix:)
      lines[start_index] = prefix.to_s + lines[start_index]
      lines[end_index] = lines[end_index] + suffix.to_s
    end

    def export
      lines.join
    end

    private

    def start_index
      start_line - 1
    end

    def end_index
      end_line - 1
    end
  end
end
