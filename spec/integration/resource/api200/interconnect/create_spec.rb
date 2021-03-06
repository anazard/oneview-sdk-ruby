# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require 'spec_helper'

klass = OneviewSDK::Interconnect
RSpec.describe klass, integration: true, type: CREATE do
  include_context 'integration context'

  let(:interconnect) { klass.find_by($client, name: 'Encl1, interconnect 1').first }
  let(:interconnect_type) { 'HP VC FlexFabric-20/40 F8 Module' }

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = klass.new($client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end

  describe '#name_servers' do
    it 'retrieves name servers' do
      expect { interconnect.name_servers }.not_to raise_error
    end
  end

  describe '#statistics' do
    it 'gets statistics' do
      expect { interconnect.statistics }.not_to raise_error
    end

    it 'gets statistics for a specific port' do
      port = interconnect[:ports].first
      expect { interconnect.statistics(port['name']) }.not_to raise_error
    end
  end

  describe '#get_types' do
    it 'retrieves interconnect types' do
      expect { klass.get_types($client) }.not_to raise_error
    end
  end

  describe '#get_type' do
    it 'retrieves the interconnect type with name' do
      interconnect_type_found = {}
      expect { interconnect_type_found = klass.get_type($client, interconnect_type) }.not_to raise_error
      expect(interconnect_type_found['name']).to eq(interconnect_type)
    end
  end
end
