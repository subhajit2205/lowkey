# frozen_string_literal: true

require_relative '../../lib/lowkey'
require_relative '../../lib/proxies/class_proxy'

class MockNode
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

RSpec.describe Lowkey::ClassProxy do
  subject(:class_proxy) { described_class.new(node: nil, namespace: 'Lowkey::A', file_proxy: nil) }

  before do
    Lowkey.configure { |config| config.cache = true }
  end

  after do
    Lowkey.clear
  end

  describe '#method_calls' do
    before do
      class_proxy.method_calls = [
        MockNode.new(:get),
        MockNode.new(:get),
        MockNode.new(:post),
        MockNode.new(:delete)
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
