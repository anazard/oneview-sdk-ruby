# Requirements:
# => 2 Server Hardware Types (any name)
# => Enclosure Group 'EnclosureGroup_1'
# => Storage System (any name)
# => Ethernet Network 'EthernetNetwork_1' (it has to be associated to the LIG 'EnclosureGroup_1' is associated to)
# => Volume 'Volume_4'
# => Storage Pool 'CPG-SSD-AO'
# => Server Profile Template (any name)

require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfile
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'can create a basic connection-less unassigned server profile' do
      item = klass.new($client_300, name: SERVER_PROFILE_NAME)
      server_hardware_type = OneviewSDK::API300::C7000::ServerHardwareType.find_by($client_300, {}).first
      enclosure_group = OneviewSDK::API300::C7000::EnclosureGroup.find_by($client_300, name: ENC_GROUP_NAME).first
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      expect { item.create }.to_not raise_error
    end

    it 'can be created from template' do
      template = OneviewSDK::API300::C7000::ServerProfileTemplate.find_by($client_300, {}).first
      item = template.new_profile(SERVER_PROFILE2_NAME)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end

    it 'can create advanced server profile with connections and volume attachments' do
      item = klass.new($client_300, name: SERVER_PROFILE3_NAME)

      server_hardware_type = OneviewSDK::API300::C7000::ServerHardwareType.find_by($client_300, {}).first
      item.set_server_hardware_type(server_hardware_type)

      enclosure_group = OneviewSDK::API300::C7000::EnclosureGroup.new($client_300, name: ENC_GROUP2_NAME)
      item.set_enclosure_group(enclosure_group)

      expect(enclosure_group['uri']).to be
      expect(server_hardware_type['uri']).to be

      storage_system = OneviewSDK::API300::C7000::StorageSystem.find_by($client_300, {}).first
      expect(storage_system['uri']).to be

      ethernet_network = OneviewSDK::API300::C7000::EthernetNetwork.new($client_300, name: ETH_NET_NAME)
      ethernet_network.retrieve!
      item.add_connection(ethernet_network, 'name' => 'eth_con_1', 'functionType' => 'Ethernet', 'portId' => 'Auto')

      volume_params = {
        'name' => VOLUME4_NAME,
        'provisioningParameters' => {
          'provisionType' => 'Full',
          'shareable' => true,
          'requestedCapacity' => 1024 * 1024 * 1024
        }
      }

      storage_pool = OneviewSDK::API300::C7000::StoragePool.new($client_300, name: STORAGE_POOL_NAME, storageSystemUri: storage_system['uri'])
      item.create_volume_with_attachment(storage_pool, volume_params)
      item['sanStorage']['manageSanStorage'] = true
      item['sanStorage']['hostOSType'] = 'Windows 2012 / WS2012 R2'

      expect { item.create }.to_not raise_error
    end
  end

  describe '#get_available_networks' do
    it 'Gets available networks' do
      item = klass.find_by($client_300, name: SERVER_PROFILE_NAME).first
      expect { item.get_available_networks }.not_to raise_error
    end
  end
end
