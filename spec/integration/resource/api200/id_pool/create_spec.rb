require 'spec_helper'

klass = OneviewSDK::IDPool
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration context'

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new($client)
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable, /The method #create is unavailable for this resource/)
    end
  end
end