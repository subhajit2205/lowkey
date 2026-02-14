# frozen_string_literal: true

require_relative '../../lib/lowkey'
require_relative '../../lib/proxies/file_proxy'

RSpec.describe Lowkey do
  let(:file_path) { 'spec/fixtures/a.rb' }

  before do
    Lowkey.configure { |config| config.cache = true }
  end

  after do
    Lowkey.clear
  end

  describe '.load' do
    let(:file_proxy) { Lowkey.load(file_path:) }

    it 'returns file proxy' do
      expect(file_proxy).to be_an_instance_of(Lowkey::FileProxy)
    end

    it 'caches file proxy' do
      file_proxy
      expect(Lowkey['spec/fixtures/a.rb']).to be_an_instance_of(Lowkey::FileProxy)
    end

    context 'without caching' do
      before do
        Lowkey.configure { |config| config.cache = false }
      end

      after do
        Lowkey.configure { |config| config.cache = true }
        Lowkey.clear
      end

      it 'does not cache file proxy' do
        expect(Lowkey['spec/fixtures/a.rb']).to be_nil
      end
    end
  end

  describe '.[]' do
    before do
      Lowkey.load(file_path:)
    end

    it 'maps file path to file proxy' do
      expect(Lowkey['spec/fixtures/a.rb']).to be_an_instance_of(Lowkey::FileProxy)
    end

    it 'maps namespace to file proxies' do
      expect(Lowkey['Lowkey::A'].first).to be_an_instance_of(Lowkey::FileProxy)
    end
  end
end
