# frozen_string_literal: true

require 'expressions'

require_relative '../proxies/method_proxy'
require_relative '../proxies/param_proxy'
require_relative '../proxies/return_proxy'

module Lowkey
  class ProxyFactory
    class << self
      def param_proxies(method_node:, file_path:, scope:)
        return [] if method_node.parameters.nil?

        # ParamProxy.new(expression:, name:, type:, file_path:, start_line:, scope:, position:)
      end

      def return_proxy(method_node:, name:, file_path:, scope:)
        return_node = return_node(method_node:)
        return nil if return_node.nil?

        start_line = method_node.start_line

        ReturnProxy.new(name:, file_path:, start_line:, scope:)
      end

      private

      # Only an unassigned lambda defined immediately after a method's parameters/block is considered a return type.
      def return_node(method_node:)
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

      def required_args(ruby_method:)
        required_args = []
        required_kwargs = {}

        ruby_method.parameters.each do |param|
          param_type, param_name = param

          case param_type
          when :req
            required_args << nil
          when :keyreq
            required_kwargs[param_name] = nil
          end
        end

        [required_args, required_kwargs]
      end
    end
  end
end
