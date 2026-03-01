# frozen_string_literal: true

require_relative '../interfaces/proxy'
require_relative '../queries/query'

module Lowkey
  class MethodProxy < Proxy
    include Query

    attr_reader :file_path, :start_line, :scope, :name, :params, :return_proxy

    # TODO: Refactor file path, start line and scope into "scope" model.
    def initialize(file_path:, start_line:, scope:, name:, param_proxies: [], return_proxy: nil) # rubocop:disable Metrics/ParameterLists
      super(file_path:, start_line:, scope:)

      @name = name
      @params = param_proxies
      @named_params = name_params
      @tagged_params = tag_params
      @return_proxy = return_proxy
    end

    def [](key)
      # TODO: Initialize method proxy with method node and support query code path.
      key.start_with?('.') ? query(node: @node, namespace: nil, name: key.delete_prefix('.')) : @named_params[key]
    end

    def tagged_params(tag)
      @tagged_params[tag] || []
    end

    def expressions?
      @params.any?(&:expression)
    end

    private

    def name_params
      @params.each_with_object({}) do |param, named_params|
        named_params[param.name] = param if %i[pos_req pos_opt key_req key_opt].include?(param.type)
      end
    end

    def tag_params
      tags = { required: [], optional: [], positional: [], keyword: [], default_value: [] }

      @params.each do |param|
        tags[:required] << param if %i[pos_req key_req].include?(param.type)
        tags[:optional] << param if %i[pos_opt key_opt].include?(param.type)
        tags[:positional] << param if %i[pos_req pos_opt].include?(param.type)
        tags[:keyword] << param if %i[key_req key_opt].include?(param.type)
        tags[:default_value] << param if param.default_value
      end

      tags
    end
  end
end
