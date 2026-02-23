# frozen_string_literal: true

require_relative '../interfaces/proxy'

module Lowkey
  class MethodProxy < Proxy
    attr_reader :file_path, :start_line, :scope, :name, :param_proxies, :return_proxy

    # TODO: Refactor file path, start line and scope into "scope" model.
    def initialize(file_path:, start_line:, scope:, name:, param_proxies: [], return_proxy: nil) # rubocop:disable Metrics/ParameterLists
      super(file_path:, start_line:, scope:)

      @name = name
      @param_proxies = param_proxies
      @return_proxy = return_proxy
    end
  end
end
