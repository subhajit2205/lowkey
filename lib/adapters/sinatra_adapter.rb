# frozen_string_literal: true

require_relative '../interfaces/adapter'

module Lowkey
  class SinatraAdapter < Adapter
    def initialize(class_proxy:)
      @class_proxy = class_proxy
      @file_path = class_proxy.file_path
    end

    def load # rubocop:disable Metrics/AbcSize
      # Type check return values.
      @class_proxy.method_calls.each do |method_call_node|
        next unless %i[get post patch put delete options].include?(method_call_node.name)

        arguments_node = method_call_node.compact_child_nodes.first
        next unless arguments_node.is_a?(Prism::ArgumentsNode)

        pattern = arguments_node.arguments.first.content
        route = "#{method_call_node.name.upcase} #{pattern}"
        name = route
        scope = route
        start_line = method_call_node.start_line

        next unless (return_proxy = ProxyFactory.return_proxy(method_node: method_call_node, name:, file_path:, scope:))

        param_proxies = [ParamProxy.new(file_path:, start_line:, scope:, name:, type: :pos_req, position: 0)]

        @class_proxy.keyed_methods[route] = MethodProxy.new(file_path:, start_line:, scope:, name:, param_proxies:, return_proxy:)
      end
    end

    private

    attr_reader :file_path
  end
end
