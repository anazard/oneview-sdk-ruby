require 'spec_helper'

klass = OneviewSDK::API300::Synergy::FCNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:file_path) { 'spec/support/fixtures/integration/fc_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::API300::Synergy::FCNetwork.from_file($client_300_synergy, file_path)
      item.create
      expect(item[:name]).to eq(FC_NET_NAME)
      expect(item[:autoLoginRedistribution]).to eq(true)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::API300::Synergy::FCNetwork.new($client_300_synergy, name: FC_NET_NAME)
      item.retrieve!
      expect(item[:name]).to eq(FC_NET_NAME)
      expect(item[:autoLoginRedistribution]).to eq(true)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::API300::Synergy::FCNetwork.find_by($client_300_synergy, {}).map { |item| item[:name] }
      expect(names).to include(FC_NET_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: FC_NET_NAME, fabricType: 'FabricAttach' }
      names = OneviewSDK::API300::Synergy::FCNetwork.find_by($client_300_synergy, attrs).map { |item| item[:name] }
      expect(names).to include(FC_NET_NAME)
    end
  end
end
