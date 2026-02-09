# frozen_string_literal: true

require 'prism'

require_relative 'visitors/visitor'
require_relative 'proxies/file_proxy'

module Lowkey
  class << self
    def files
      @files ||= {}
    end

    def parse(file_path:)
      root_node = Prism.parse_file(file_path).value
      file_proxy = FileProxy.new(path: file_path, root_node:)

      parent_map = ParentMap.new(root_node:)
      visitor = Visitor.new(file_proxy:, parent_map:)
      root_node.accept(visitor)

      files[file_path] = file_proxy
    end

    def [](file_path)
      files[file_path]
    end

    def clear
      files = {}
    end
  end
end
