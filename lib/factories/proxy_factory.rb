# frozen_string_literal: true

require_relative '../factories/scope_factory'
require_relative '../proxies/class_proxy'
require_relative '../proxies/file_proxy'
require_relative '../proxies/method_proxy'
require_relative '../proxies/param_proxy'
require_relative '../proxies/return_proxy'

module Lowkey
  class ProxyFactory
    class << self
      def file_proxy(root_node:, file_path:)
        scope = ScopeFactory.file_scope(root_node:, file_path:)
        FileProxy.new(root_node:, scope:)
      end

      def class_proxy(node:, namespace:, file_path:, lines:)
        scope = ScopeFactory.class_scope(node:, namespace:, file_path:, lines:)
        name = node.respond_to?(:name) ? node.name : 'Object'
        ClassProxy.new(node:, name:, namespace:, scope:)
      end

      def param_proxies(parameters_node:, scope:, file_path:)
        return [] if parameters_node.nil?

        param_types = {
          Prism::RequiredParameterNode => :pos_req,
          Prism::OptionalParameterNode => :pos_opt,
          Prism::RequiredKeywordParameterNode => :key_req,
          Prism::OptionalKeywordParameterNode => :key_opt
        }

        params = [*parameters_node.requireds, *parameters_node.optionals, *parameters_node.keywords]
        params.map.with_index do |param, position|
          name = param.name
          scope = ScopeFactory.param_scope(param_node: param, file_path:, lines: scope.lines)
          type = param_types[param.class]
          value = param.respond_to?(:value) ? param.value.slice : ':LOWKEY_UNDEFINED'

          ParamProxy.new(name:, scope:, type:, position:, value:)
        end
      end

      def return_proxy(method_node:, name:, scope:)
        return_node = find_return_node(method_node:)
        return nil if return_node.nil?

        start_line = return_node.start_line
        value = return_node.body.slice

        ReturnProxy.new(name:, scope:, value:)
      end

      private

      # A return type is an unassigned lambda defined immediately after a method's parameters/block.
      def find_return_node(method_node:)
        # Method statements.
        statements_node = method_node.compact_child_nodes.find { |node| node.is_a?(Prism::StatementsNode) }

        # Block statements.
        if statements_node.nil?
          block_node = method_node.compact_child_nodes.find { |node| node.is_a?(Prism::BlockNode) }
          statements_node = block_node.compact_child_nodes.find { |node| node.is_a?(Prism::StatementsNode) } if block_node
        end

        return nil if statements_node.nil? # Sometimes developers define methods without code inside them.

        node = statements_node.body.first
        return node if node.is_a?(Prism::LambdaNode)

        nil
      end
    end
  end
end
