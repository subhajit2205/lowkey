# frozen_string_literal: true

require_relative '../../lib/lowkey'
require_relative '../fixtures/instance_methods'

RSpec.describe Lowkey::InstanceMethods do
  subject(:instance_methods) { file_proxy.definitions['Lowkey::InstanceMethods'] }

  let(:file_proxy) { Lowkey.load('spec/fixtures/instance_methods.rb') }

  it 'has method' do
    expect(instance_methods[:method]).not_to be_nil
  end

  it 'has method with arg' do
    expect(instance_methods[:method_with_arg]).not_to be_nil
  end
end
