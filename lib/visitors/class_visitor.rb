# frozen_string_literal: true

require_relative '../factories/proxy_factory'
require_relative '../queries/query'

module Lowkey
  class ClassVisitor
    include Query

    def initialize(file_proxy:, parent_map:)
      @file_proxy = file_proxy
      @parent_map = parent_map
    end

    def visit(node)
      namespace = namespace(node:, parent_map:)
      class_proxy = ProxyFactory.class_proxy(node:, namespace:, file_path:, lines:)
      @file_proxy.upsert_definition(module_proxy: class_proxy)
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
