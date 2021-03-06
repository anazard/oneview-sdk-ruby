require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardware, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware_ip']).first
  end

  describe '#set_refresh_state' do
    it 'Refresh state with no additional parameters' do
      expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
    end

    it 'Refresh state with additional parameters' do
      expect { @item.set_refresh_state('RefreshPending', resfreshActions: 'ClearSyslog') }.not_to raise_error
    end
  end

  describe '#power' do
    it 'Power off server hardware' do
      expect { @item.power_off }.not_to raise_error
    end

    it 'Power on server hardware' do
      expect { @item.power_on }.not_to raise_error
    end

    it 'Force power off server hardware' do
      expect { @item.power_off(true) }.not_to raise_error
    end
  end

  describe '#update_ilo_firmware' do
    it 'Update iLO firmware to OneView minimum supported version' do
      expect { @item.update_ilo_firmware }.not_to raise_error
    end
  end

end
