# frozen_string_literal: true

require_relative '../factories/source_factory'

require_relative '../proxies/body_proxy'
require_relative '../proxies/class_proxy'
require_relative '../proxies/file_proxy'
require_relative '../proxies/method_proxy'
require_relative '../proxies/module_proxy'
require_relative '../proxies/param_proxy'
require_relative '../proxies/return_proxy'

module Lowkey
  class ProxyFactory
    class << self
      def file_proxy(root_node:, file_path:)
        source = SourceFactory.file_source(root_node:, file_path:)
        FileProxy.new(root_node:, source:)
      end

      def module_proxy(node:, namespace:, file_path:, lines:)
        source = SourceFactory.module_source(node:, namespace:, file_path:, lines:)
        name = node.respond_to?(:name) ? node.name : 'Object'
        ModuleProxy.new(node:, name:, namespace:, source:)
      end

      def class_proxy(node:, namespace:, file_path:, lines:)
        source = SourceFactory.class_source(node:, file_path:, lines:)
        ClassProxy.new(node:, name: node.name, namespace:, source:)
      end

      def method_proxy(method_node:, file_proxy:)
        name = method_node.name

        method_source = SourceFactory.method_source(method_node:, file_path: file_proxy.file_path, lines: file_proxy.lines)
        body_source = SourceFactory.body_source(method_source:)

        param_proxies = param_proxies(parameters_node: method_node.parameters, file_path: file_proxy.file_path, source: method_source)
        body_proxy = BodyProxy.new(name:, source: body_source)
        return_proxy = return_proxy(name:, method_node:, source: method_source)

        MethodProxy.new(name:, source: method_source, param_proxies:, body_proxy:, return_proxy:)
      end

      def param_proxies(parameters_node:, source:, file_path:)
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
          source = SourceFactory.param_source(param_node: param, file_path:, lines: source.lines)
          type = param_types[param.class]
          value = param.respond_to?(:value) ? param.value.slice : ':LOWKEY_UNDEFINED'

          ParamProxy.new(name:, source:, type:, position:, value:)
        end
      end

      def return_proxy(method_node:, name:, source:)
        return_node = find_return_node(method_node:)
        return nil if return_node.nil?

        value = return_node.body.slice

        ReturnProxy.new(name:, source:, value:)
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
