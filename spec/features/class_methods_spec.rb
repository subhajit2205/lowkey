# frozen_string_literal: true

require_relative '../fixtures/class_methods'

RSpec.describe Lowkey::ClassMethods do
  subject(:class_methods) { file_proxy.definitions['Lowkey::ClassMethods'] }

  let(:file_proxy) { Lowkey.load(file_path: 'spec/fixtures/class_methods.rb') }

  it 'has inline class method' do
    expect(class_methods[:inline_class_method]).not_to be_nil
  end

  it 'has inline class method with arg' do
    expect(class_methods[:inline_class_method_with_arg]).not_to be_nil
  end

  it 'has class method' do
    expect(class_methods[:class_method_with_arg]).not_to be_nil
  end

  it 'has class method with arg' do
    expect(class_methods[:class_method_with_arg_and_default_value]).not_to be_nil
  end
end
