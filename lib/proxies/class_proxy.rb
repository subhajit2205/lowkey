# frozen_string_literal: true

require_relative '../interfaces/proxy'
require_relative '../queries/query'

module Lowkey
  class ClassProxy < Proxy
    include Query

    attr_reader :namespace
    attr_accessor :private_start_line, :keyed_methods, :class_methods, :instance_methods, :method_calls
    
    def start_line
      @node.location.start_line
    end

    def end_line
      @node.location.end_line
    end

    def initialize(node:, name:, namespace:, source:)
      super(name:, source:)

      @node = node
      @namespace = namespace

      @private_start_line = nil

      @keyed_methods = {}
      @class_methods = {}
      @instance_methods = {}

      @method_calls = []
    end

    def [](key)
      key.start_with?('.') ? query(node: @node, namespace: nil, name: key.delete_prefix('.')) : @keyed_methods[key]
    end

    class << self
      def class_method?(method_node:, parent_map:)
        return true if method_node.is_a?(::Prism::DefNode) && method_node.receiver.instance_of?(Prism::SelfNode) # self.method_name
        return true if method_node.is_a?(::Prism::SingletonClassNode) # class << self

        if (parent_node = parent_map[method_node])
          return class_method?(method_node: parent_node, parent_map:)
        end

        false
      end
    end
  end
end
