# frozen_string_literal: true

require_relative '../factories/scope_factory'
require_relative '../factories/proxy_factory'
require_relative '../queries/query'

module Lowkey
  class MethodDefVisitor
    include Query

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map
    end
    
    def visit(method_node) # rubocop:disable Metrics/AbcSize
      namespace = namespace(node: method_node, parent_map:)
      class_proxy = @file_proxy[namespace]
      
      name = method_node.name
      scope = ScopeFactory.method_scope(method_node:, file_path: @file_proxy.file_path, lines: @file_proxy.lines)
      
      param_proxies = ProxyFactory.param_proxies(parameters_node: method_node.parameters, file_path: @file_proxy.file_path, scope:)
      return_proxy = ProxyFactory.return_proxy(name:, method_node:, scope:)
      method_proxy = MethodProxy.new(name:, scope:, param_proxies:, return_proxy:)
      
      class_proxy.keyed_methods[method_node.name] = method_proxy
      
      # TODO: Implemented as sorted methods similar to sorted params.
      if ClassProxy.class_method?(method_node:, parent_map:)
        class_proxy.class_methods[method_node.name] = method_proxy
      else
        class_proxy.instance_methods[method_node.name] = method_proxy
      end
    end

    private

    attr_reader :parent_map
  end
end
