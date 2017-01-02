require 'spec_helper'

klass = OneviewSDK::API300::C7000::UplinkSet
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:uplink_data_path) { 'spec/support/fixtures/integration/uplink_set_ethernet.json' }

  let(:log_int) { OneviewSDK::API300::C7000::LogicalInterconnect.get_all($client_300).first }

  describe '#create' do
    it 'can create the uplink and attach to a Logical Interconnect' do
      item = klass.from_file($client_300, uplink_data_path)
      item[:logicalInterconnectUri] = log_int[:uri]
      expect { item.create }.not_to raise_error
      expect(item[:uri]).to be
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#get_unassigned_ports' do
    it 'should return a hash with the unassigned uplink set ports' do
      uplink = klass.new($client_300, name: UPLINK_SET4_NAME)
      expect(uplink.retrieve!).to eq(true)
      ports = uplink.get_unassigned_ports
      expect(ports.class).to eq(Hash)
      expect(ports['members']).not_to be_empty
    end
  end

  describe '::get_schema' do
    it 'should return the JSON schema' do
      schema = klass.get_schema($client_300)
      expect(schema).to be
      expect(schema.class).to eq(Hash)
    end
  end
end
