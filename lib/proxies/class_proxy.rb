# frozen_string_literal: true

require_relative 'module_proxy'

module Lowkey
  class ClassProxy < ModuleProxy
    attr_accessor :instance_methods

    def initialize(node:, name:, namespace:, source:)
      super(node:, name:, namespace:, source:)

      @instance_methods = {}
    end
  end
end
