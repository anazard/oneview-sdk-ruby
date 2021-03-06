# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, binding.pryeither express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::API300::C7000::PowerDevice
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @ipdu_list = klass.find_by($client_300, 'managedBy' => { 'hostName' => $secrets['hp_ipdu_ip'] })
    @item = @ipdu_list.reject { |ipdu| ipdu['managedBy']['id'] == ipdu['id'] }.first
  end

  describe '#update' do
    it 'Change name' do
      name = @item['name']
      @item.update(name: 'PowerDevice_Name_Updated')
      expect(@item['name']).to eq('PowerDevice_Name_Updated')
      @item.refresh
      @item.update(name: name)
    end
  end

  describe '#set_refresh_state' do
    it 'Refresh without changing credentials' do
      expect { @item.set_refresh_state(refreshState: 'RefreshPending') }.not_to raise_error
    end

    it 'Refresh with new credentials' do
      options = {
        refreshState: 'RefreshPending',
        username: $secrets['hp_ipdu_username'],
        password: $secrets['hp_ipdu_password']
      }
      expect { @item.set_refresh_state(options) }.not_to raise_error
    end
  end

  describe '#set_power_state' do
    it 'On|off state on a device that supports this operation' do
      power_device = @ipdu_list.reject { |ipdu| ipdu['model'] != 'Managed Ext. Bar Outlet' }.first
      expect { power_device.set_power_state('On') }.not_to raise_error
    end
  end

  describe '#set_uid_state' do
    it 'On|off' do
      expect { @item.set_uid_state('On') }.not_to raise_error
    end
  end
end
