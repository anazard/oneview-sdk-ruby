require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalEnclosure
extra_klass_1 = OneviewSDK::API300::Thunderbird::EnclosureGroup
extra_klass_2 = OneviewSDK::API300::Thunderbird::Enclosure
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before :each do
    @enclosure_group = extra_klass_1.find_by($client_300_thunderbird, {}).first
    @enclosure = extra_klass_2.find_by($client_300_thunderbird, {}).first
  end

  describe '#create' do
    it 'create a logical enclosure' do
      item = klass.new($client_300_thunderbird, name: LOG_ENCL1_NAME, forceInstallFirmware: false, firmwareBaselineUri: nil)
      item.set_enclosure_group(@enclosure_group)
      item.set_enclosures([@enclosure])
      expect { item.create }.to_not raise_error
      result = klass.find_by($client_300_thunderbird, name: LOG_ENCL1_NAME).first
      expect(result['uri']).to be_truthy
      expect(result['enclosureGroupUri']).to eq(item['enclosureGroupUri'])
      expect(result['enclosureUris']).to eq(item['enclosureUris'])
      expect(result['enclosures'].size).to eq(1)
      expect(result['enclosures'].key?(item['enclosureUris'].first)).to be true
    end
  end
end