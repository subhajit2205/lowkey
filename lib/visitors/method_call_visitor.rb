# frozen_string_literal: true

require_relative '../queries/query'

module Lowkey
  class MethodCallVisitor
    include Query

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map
    end

    def visit(node)
      namespace = namespace(node:, parent_map:)
      class_proxy = @file_proxy[namespace]
      class_proxy.method_calls ||= []
      class_proxy.method_calls << node

      return unless node.name == :private 

      node_start_line = node.location.start_line

      can_check_bounds = class_proxy.respond_to?(:start_line) && class_proxy.respond_to?(:end_line)
      can_assign = class_proxy.respond_to?(:private_start_line=)
       
      return unless can_check_bounds && can_assign
      
      c_start = class_proxy.start_line
      c_end   = class_proxy.end_line

      if c_start && c_end && node_start_line > c_start && node_start_line < c_end
        class_proxy.private_start_line = node_start_line
      end
    end

    private

    attr_reader :parent_map
  end
end
