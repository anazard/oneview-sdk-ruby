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

require_relative '../_client' # Gives access to @client

# Example: Create an ethernet network
# NOTE: This will create an ethernet network named 'OneViewSDK Test Vlan', then delete it.
options = {
  vlanId:  '1001',
  purpose:  'General',
  name:  'OneViewSDK Test Vlan',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil,
  type:  'ethernet-networkV3'
}

# Creating a ethernet network
ethernet = OneviewSDK::EthernetNetwork.new(@client, options)
ethernet.create
puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'"

# Find recently created network by name
matches = OneviewSDK::EthernetNetwork.find_by(@client, name: ethernet[:name])
ethernet2 = matches.first
puts "\nFound ethernet-network by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"

# Update purpose and smartLink settings from recently created network
attributes = {
  purpose: 'Management',
  smartLink: true
}
ethernet2.update(attributes)
puts "\nUpdated ethernet-network: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"
puts "with attributes: #{attributes}"

# Get associated profiles
puts "\nSuccessfully retrieved associated profiles: #{ethernet2.get_associated_profiles}"

# Get associated uplink groups
puts "\nSuccessfully retrieved associated uplink groups: #{ethernet2.get_associated_uplink_groups}"

# Retrieve recently created network
ethernet3 = OneviewSDK::EthernetNetwork.new(@client, name: ethernet[:name])
ethernet3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet3[:uri]}'"

# Example: List all ethernet networks with certain attributes
attributes = { purpose: 'Management' }
puts "\n\nEthernet networks with #{attributes}"
OneviewSDK::EthernetNetwork.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# Delete this network
ethernet2.delete
puts "\nSucessfully deleted ethernet-network '#{ethernet[:name]}'."


# Bulk create ethernet networks
options = {
  vlanIdRange: '26-28',
  purpose: 'General',
  namePrefix: 'OneViewSDK_Bulk_Network',
  smartLink: false,
  privateNetwork: false,
  bandwidth: {
    maximumBandwidth: 10_000,
    typicalBandwidth: 2000
  }
}

list = OneviewSDK::EthernetNetwork.bulk_create(@client, options).each { |network| puts network['uri'] }

puts "\nBulk-created ethernet networks '#{options[:namePrefix]}_<x>' sucessfully."

list.sort_by! { |e| e['name'] }
list.each { |e| puts "  #{e['name']}" }

# Clean up
list.map(&:delete)
puts "\nDeleted all bulk-created ethernet networks sucessfully.\n"
