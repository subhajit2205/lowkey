# frozen_string_literal: true

require 'prism'

require_relative 'visitors/visitor'
require_relative 'proxies/file_proxy'

module Lowkey
  class << self
    def keys
      @keys ||= {}
    end

    def [](key)
      keys[key]
    end

    def load(file_path:)
      root_node = Prism.parse_file(file_path).value
      file_proxy = FileProxy.new(path: file_path, root_node:)

      parent_map = ParentMap.new(root_node:)
      visitor = Visitor.new(file_proxy:, parent_map:)
      root_node.accept(visitor)

      if Lowkey.config.cache
        map_file_path(file_proxy:)
        map_definitions(file_proxy:)
      end

      file_proxy
    end

    def clear
      keys.clear
    end

    def config
      config = Struct.new(:cache)
      @config ||= config.new(false)
    end

    def configure
      yield(config)
    end

    private

    def map_file_path(file_proxy:)
      keys[file_proxy.path] = file_proxy
    end

    def map_definitions(file_proxy:)
      file_proxy.definitions.each_key do |namespace|
        keys[namespace] ||= []
        keys[namespace] << file_proxy
      end
    end
  end
end
