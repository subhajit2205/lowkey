# frozen_string_literal: true

require_relative '../interfaces/proxy'
require_relative '../proxies/class_proxy'
require_relative '../queries/query'

module Lowkey
  class FileProxy < Proxy
    include Query

    attr_reader :root_node
    attr_accessor :definitions, :dependencies

    def initialize(root_node:, source:)
      super(name: nil, source:)

      @root_node = root_node

      @definitions = {}
      @dependencies = []
    end

    def [](keypath)
      namespace, *file_path = keypath.split('.')
      file_path.empty? ? @definitions[namespace] : query(node: @root_node, namespace:, name: file_path.join)
    end

    def []=(keypath, value)
      # TODO: Slice the lines in a file and replace with the output of the class proxy.
    end

    def upsert_class_proxy(class_proxy:)
      # TODO: Merge duplicate class with existing class.
      @definitions[class_proxy.namespace] ||= class_proxy
    end
  end
end
