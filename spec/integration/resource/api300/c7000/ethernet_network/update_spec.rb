require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::EthernetNetwork, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'update name' do
      item = OneviewSDK::API300::C7000::EthernetNetwork.new($client_300, name: ETH_NET_NAME)
      item.retrieve!
      item.update(name: ETH_NET_NAME_UPDATED)
      item.refresh
      expect(item[:name]).to eq(ETH_NET_NAME_UPDATED)
      item.update(name: ETH_NET_NAME)
      item.refresh
      expect(item[:name]).to eq(ETH_NET_NAME)
    end
  end
end
