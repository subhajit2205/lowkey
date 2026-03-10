# frozen_string_literal: true

require 'forwardable'

module Lowkey
  # Proxy and Scope abstract away nodes and avoid referencing the node on the proxy itself. Will this change?
  # The goal is to make an API that's indiependent of the AST, that can manipulate source code line by line.
  class Proxy
    extend Forwardable

    attr_reader :name

    def_delegator :@scope, :file_path
    def_delegator :@scope, :lines
    def_delegator :@scope, :start_line
    def_delegator :@scope, :scope

    def initialize(name:, scope:)
      @name = name
      @scope = scope
    end
  end
end
