require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalInterconnect
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  # Cannot create individually
end
