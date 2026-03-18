# frozen_string_literal: true

require_relative '../factories/proxy_factory'
require_relative '../queries/query'

module Lowkey
  class ModuleVisitor
    include Query

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map

      create_root_module
    end

    def visit(node)
      namespace = namespace(node:, parent_map:)
      module_proxy = ProxyFactory.module_proxy(node:, namespace:, file_path:, lines:)
      @file_proxy.upsert_definition(module_proxy:)
    end

    private

    def create_root_module
      module_proxy = ProxyFactory.module_proxy(node: @file_proxy.root_node, namespace: 'Object', file_path:, lines:)
      @file_proxy.upsert_definition(module_proxy:)
    end

    attr_reader :parent_map

    def file_path
      @file_proxy.file_path
    end

    def lines
      @file_proxy.lines
    end
  end
end
