# frozen_string_literal: true

require_relative '../models/scope'

module Lowkey
  class ScopeFactory
    class << self
      # @param node: Either the class node or the main object node.
      def class_scope(node:, namespace:, file_path:)
        start_line = node.respond_to?(:class_keyword_loc) ? node.class_keyword_loc.start_line : 0
        end_line = node.respond_to?(:end_keyword_loc) ? node.end_keyword_loc.end_line : start_line
        end_line = node.end_line if namespace == 'Object'
        scope = node.respond_to?(:name) ? node.name : 'Object'

        Scope.new(file_path:, scope:, start_line:, end_line:)
      end

      def param_scope(param_node:, file_path:)
        scope = param_node.name
        start_line = param_node.start_line
        end_line = param_node.end_line

        Scope.new(file_path:, scope:, start_line:, end_line:)
      end

      def method_scope(method_node:, file_path:)
        scope = method_node.name
        start_line = method_node.start_line

        Scope.new(file_path:, scope:, start_line:)
      end

      def method_call_scope(method_call_node:, arguments_node:, file_path:)
        pattern = arguments_node.arguments.first.content
        scope = "#{method_call_node.name.upcase} #{pattern}"
        start_line = method_call_node.start_line
        scope = method_call_node.name

        Scope.new(file_path:, scope:, start_line:)
      end
    end
  end
end
