# frozen_string_literal: true

require 'prism'
require_relative '../../lib/proxies/class_proxy'

class MockCallNode
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

RSpec.describe Lowkey::ClassProxy do
  subject(:class_proxy) { described_class.new(node:, namespace: 'Lowkey::MockClass', file_proxy: nil) }

  let(:node) do
    root_node = Prism.parse_file('spec/fixtures/mock_node.rb').value
    root_node.breadth_first_search { |n| n.instance_of?(Prism::ClassNode) }
  end

  describe '.[]' do
    context 'with method proxy' do
      before do
        method_proxy = Lowkey::MethodProxy.new(file_path: 'mock/path', start_line: 123, scope: 'mock scope', name: 'mock name')
        class_proxy.keyed_methods[:render] = method_proxy
      end

      it 'returns a method proxy' do
        expect(class_proxy[:render]).to be_an_instance_of(Lowkey::MethodProxy)
      end

      it 'returns a method node' do
        expect(class_proxy['.render']).to be_an_instance_of(Prism::DefNode)
      end
    end
  end

  describe '#method_calls' do
    before do
      class_proxy.method_calls = [
        MockCallNode.new(:get),
        MockCallNode.new(:get),
        MockCallNode.new(:post),
        MockCallNode.new(:delete)
      ]
    end

    context 'without arg' do
      subject(:method_calls) { class_proxy.method_calls }

      it 'returns all method calls' do
        expect(method_calls.count).to eq(4)
      end
    end

    context 'with arg' do
      subject(:method_calls) { class_proxy.method_calls(%i[post delete]) }

      it 'returns filtered method calls' do
        expect(method_calls.count).to eq(2)
      end
    end
  end
end
