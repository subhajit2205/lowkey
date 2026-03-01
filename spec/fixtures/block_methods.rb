# frozen_string_literal: true

class MockSinatra
  def self.get(_route) = yield
end

module Lowkey
  class BlockMethods < MockSinatra
    get('one') do -> { 'mock return type' }
      200
    end
  end
end
