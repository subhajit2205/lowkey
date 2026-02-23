# frozen_string_literal: true

module Lowkey
  class ClassProxy
    attr_reader :namespace, :start_line, :end_line
    attr_writer :method_calls
    attr_accessor :private_start_line, :class_methods, :instance_methods

    def initialize(node:, namespace:, file_proxy:)
      @namespace = namespace
      @file_proxy = file_proxy

      @start_line = node.respond_to?(:class_keyword_loc) ? node.class_keyword_loc.start_line : 0
      @end_line = node.respond_to?(:end_keyword_loc) ? node.end_keyword_loc.end_line : @start_line
      @end_line = file_proxy.end_line if namespace == 'Object'
      @private_start_line = nil

      @class_methods = {}
      @instance_methods = {}
      @method_calls = []
    end

    def method_calls(method_names = nil)
      return @method_calls if method_names.nil?

      @method_calls.filter { |method_call| method_names.include?(method_call.name) }
    end

    def file_path
      @file_proxy.path
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
