# frozen_string_literal: true

require_relative '../factories/proxy_factory'

module Lowkey
  class MethodDefVisitor
    attr_reader :parent_map

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map
    end

    def visit(method_node)
      class_proxy = @file_proxy.upsert_class_proxy(node: method_node, parent_map:)
      name = method_node.name
      scope = name

      param_proxies = ProxyFactory.param_proxies(method_node:, file_path:, scope:)
      return_proxy = ProxyFactory.return_proxy(name:, method_node:, file_path:, scope:)
      method_proxy = MethodProxy.new(file_path:, start_line: method_node.start_line, scope:, name:, param_proxies:, return_proxy:)

      if ClassProxy.class_method?(method_node:, parent_map:)
        class_proxy.class_methods[method_node.name] = method_proxy
      else
        class_proxy.instance_methods[method_node.name] = method_proxy
      end
    end

    private

    def file_path
      @file_proxy.path
    end
  end
end
