# frozen_string_literal: true

require_relative '../models/source'

module Lowkey
  class SourceFactory
    class << self
      def file_source(root_node:, file_path:)
        end_line = root_node.respond_to?(:end_line) ? root_node.end_line : nil

        Source.new(file_path:, scope: 'file', lines: root_node.script_lines, start_line: 0, end_line:)
      end

      def module_source(node:, namespace:, file_path:, lines:)
        start_line = node.respond_to?(:class_keyword_loc) ? node.class_keyword_loc.start_line : 0
        end_line = node.respond_to?(:end_keyword_loc) ? node.end_keyword_loc.end_line : start_line
        end_line = node.end_line if namespace == 'Object'
        scope = node.respond_to?(:name) ? node.name : 'Object'

        Source.new(file_path:, scope:, lines:, start_line:, end_line:)
      end

      def class_source(node:, file_path:, lines:)
        start_line = node.respond_to?(:class_keyword_loc) ? node.class_keyword_loc.start_line : 0
        end_line = node.respond_to?(:end_keyword_loc) ? node.end_keyword_loc.end_line : start_line

        Source.new(file_path:, scope: node.name, lines:, start_line:, end_line:)
      end

      def method_source(method_node:, file_path:, lines:)
        scope = method_node.name
        start_line = method_node.start_line
        end_line = method_node.end_line
        end_line = end_line_from_indent(method_node:, lines:) if end_line > lines.count

        Source.new(file_path:, scope:, lines:, start_line:, end_line:)
      end

      def param_source(param_node:, file_path:, lines:)
        scope = param_node.name
        start_line = param_node.start_line
        end_line = param_node.end_line

        Source.new(file_path:, scope:, lines:, start_line:, end_line:)
      end

      def body_source(method_source:)
        # TODO: Handle multi-line return proxy which increases body start line.
        start_line = method_source.start_line + 1
        end_line = method_source.end_line - 1

        Source.new(file_path: method_source.file_path, scope: method_source.scope, lines: method_source.lines, start_line:, end_line:)
      end

      def method_call_source(method_call_node:, arguments_node:, file_path:, lines:)
        pattern = arguments_node.arguments.first.content
        scope = "#{method_call_node.name.upcase} #{pattern}"
        start_line = method_call_node.start_line
        end_line = method_call_node.end_line

        Source.new(file_path:, scope:, lines:, start_line:, end_line:)
      end

      private

      # TODO: end_line = start_line if it's an endless method like "def method = expression".
      def end_line_from_indent(method_node:, lines:)
        end_index = nil

        index = method_node.start_line - 1
        indent = lines[index].split('def').first

        while end_index.nil?
          end_index = index if lines[index].nil?
          end_index = index if lines[index].start_with?("#{indent}end")
          index += 1
        end

        end_index + 1
      end
    end
  end
end
