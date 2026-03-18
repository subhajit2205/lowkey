# frozen_string_literal: true

require_relative '../factories/source_factory'
require_relative '../factories/proxy_factory'
require_relative '../proxies/method_proxy'
require_relative '../queries/query'

module Lowkey
  class MethodDefVisitor
    include Query

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map
    end

    def visit(method_node)
      namespace = namespace(node: method_node, parent_map:)
      module_proxy = file_proxy[namespace]
      method_proxy = ProxyFactory.method_proxy(method_node:, file_proxy:)

      module_proxy.keyed_methods[method_node.name] = method_proxy

      # TODO: Implemented as tagged methods similar to tagged params.
      if ModuleProxy.class_method?(method_node:, parent_map:)
        module_proxy.class_methods[method_node.name] = method_proxy
      elsif module_proxy.class <= ClassProxy
        module_proxy.instance_methods[method_node.name] = method_proxy
      end
    end

    private

    attr_reader :file_proxy, :parent_map
  end
end
