# frozen_string_literal: true

require_relative 'class_visitor'
require_relative 'module_visitor'
require_relative 'method_def_visitor'
require_relative 'method_call_visitor'

module Lowkey
  class Visitor < Prism::Visitor
    def initialize(file_proxy:, parent_map:)
      @class_visitor = ClassVisitor.new(file_proxy:, parent_map:)
      @module_visitor = ModuleVisitor.new(file_proxy:, parent_map:)
      @method_def_visitor = MethodDefVisitor.new(file_proxy:, parent_map:)
      @method_call_visitor = MethodCallVisitor.new(file_proxy:, parent_map:)
    end

    def visit_class_node(node)
      @class_visitor.visit(node)
      super
    end

    def visit_module_node(node)
      @module_visitor.visit(node)
      super
    end

    def visit_def_node(node)
      @method_def_visitor.visit(node)
      super
    end

    def visit_call_node(node)
      @method_call_visitor.visit(node)
      super
    end
  end
end
