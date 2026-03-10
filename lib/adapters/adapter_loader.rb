# frozen_string_literal: true

require_relative 'sinatra_adapter'
require_relative '../proxies/class_proxy'

module Lowkey
  class AdapterLoader
    class << self
      def load(file_proxy:)
        class_proxies = file_proxy.definitions.values.filter { |definition| definition.instance_of?(ClassProxy) }
        class_proxies.each do |class_proxy|
          SinatraAdapter.new(file_proxy:, class_proxy:).load
        end
      end
    end
  end
end
