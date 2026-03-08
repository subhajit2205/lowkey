# frozen_string_literal: true

require_relative '../proxies/method_proxy'
require_relative '../proxies/param_proxy'
require_relative '../proxies/return_proxy'

module Lowkey
  class ProxyFactory
    class << self
      def param_proxies(parameters_node:, file_path:, scope:)
        return [] if parameters_node.nil?

        param_types = {
          Prism::RequiredParameterNode => :pos_req,
          Prism::OptionalParameterNode => :pos_opt,
          Prism::RequiredKeywordParameterNode => :key_req,
          Prism::OptionalKeywordParameterNode => :key_opt
        }

        params = [*parameters_node.requireds, *parameters_node.optionals, *parameters_node.keywords]
        params.map.with_index do |param, position|
          type = param_types[param.class]
          name = param.name
          scope = name
          start_line = param.start_line
          value = param.respond_to?(:value) ? param.value.slice : ':LOWKEY_UNDEFINED'

          ParamProxy.new(file_path:, start_line:, scope:, name:, type:, position:, value:)
        end
      end

      def return_proxy(method_node:, name:, file_path:, scope:)
        return_node = find_return_node(method_node:)
        return nil if return_node.nil?

        start_line = return_node.start_line
        value = return_node.body.slice

        ReturnProxy.new(name:, file_path:, start_line:, scope:, value:)
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
