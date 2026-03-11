# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class BodyProxy < Proxy
    def initialize(name:, source:)
      super(name:, source:)
    end
  end
end
