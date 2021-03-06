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

require_relative '../../_client' # Gives access to @client

# Retrieves all switch types from the Appliance
OneviewSDK::API300::Synergy::Switch.get_types(@client).each do |type|
  puts "Switch Type: #{type['name']}\nURI: #{type['uri']}\n\n"
end

# Retrieves switch type by name
item = OneviewSDK::API300::Synergy::Switch.get_type(@client, 'Cisco Nexus 50xx')
puts "Switch Type by name: #{item['name']}\nURI: #{item['uri']}\n\n"
