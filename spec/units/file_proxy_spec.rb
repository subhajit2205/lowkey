# frozen_string_literal: true

require 'prism'

require_relative '../../lib/lowkey'
require_relative '../fixtures/mock_node'

RSpec.describe 'FileProxy' do
  subject(:file_proxy) { Lowkey.load(file_path: 'spec/fixtures/mock_node.rb') }

  describe '.[]' do
    it 'returns a class proxy' do
      expect(file_proxy['Lowkey::MockNode']).to be_an_instance_of(Lowkey::ClassProxy)
    end

    it 'returns a method proxy' do
      expect(file_proxy['Lowkey::MockNode.render']).to be_an_instance_of(Lowkey::MethodProxy)
    end
  end
end
