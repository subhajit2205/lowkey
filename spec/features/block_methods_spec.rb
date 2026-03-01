# frozen_string_literal: true

require_relative '../../lib/lowkey'
require_relative '../fixtures/block_methods'

RSpec.describe Lowkey::BlockMethods do
  subject(:block_methods) { file_proxy.definitions['Lowkey::BlockMethods'] }

  let(:file_proxy) { Lowkey.load(file_path: 'spec/fixtures/block_methods.rb') }

  it 'creates block method proxy' do
    expect(block_methods['GET one']).not_to be_nil
  end
end
