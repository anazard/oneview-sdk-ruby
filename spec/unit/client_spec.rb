require_relative './../spec_helper'

RSpec.describe OneviewSDK::Client do

  describe '#initialize' do
    it 'creates a client with valid credentials' do
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to_not be_nil
    end

    it 'creates a client with a token' do
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('token123')
    end

    it 'requires a token or user-password pair' do
      options = { url: 'https://oneview.example.com', user: 'Administrator' }
      expect { OneviewSDK::Client.new(options) }.to raise_error(/Must set user & password options or token/)
    end

    it 'requires the url attribute to be set' do
      expect { OneviewSDK::Client.new({}) }.to raise_error(/Must set the url option/)
    end

    it 'sets the username to "Administrator" by default' do
      options = { url: 'https://oneview.example.com', password: 'secret123' }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/User option not set. Using default/).to_stdout_from_any_process
      expect(client.user).to eq('Administrator')
    end

    it 'respects credential environment variables' do
      ENV['ONEVIEWSDK_USER'] = 'Admin'
      ENV['ONEVIEWSDK_PASSWORD'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.user).to eq('Admin')
      expect(client.password).to eq('secret456')
    end

    it 'respects the token environment variable' do
      ENV['ONEVIEWSDK_TOKEN'] = 'secret456'
      client = OneviewSDK::Client.new(url: 'https://oneview.example.com')
      expect(client.token).to eq('secret456')
    end

    it 'sets the log level' do
      options = { url: 'https://oneview.example.com', password: 'secret123', log_level: :error }
      client = OneviewSDK::Client.new(options)
      expect(client.log_level).to eq(:error)
      expect(client.logger.level).to eq(3)
    end

    it 'picks the lower of the default api version and appliance api version' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_return(120)
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.api_version).to eq(120)
    end

    it 'warns if the api level is greater than the appliance api version' do
      options = { url: 'https://oneview.example.com', token: 'token123', api_version: 300 }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(/is greater than the appliance API version/).to_stdout_from_any_process
      expect(client.api_version).to eq(300)
    end
  end

  describe '#appliance_api_version' do
    before :each do
      allow_any_instance_of(OneviewSDK::Client).to receive(:appliance_api_version).and_call_original
    end

    it 'gets the api version from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return('currentVersion' => '120')
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = OneviewSDK::Client.new(options)
      expect(client.api_version).to eq(120)
    end

    it 'sets a default api version value when it cannot be obtained from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return({})
      options = { url: 'https://oneview.example.com', token: 'token123' }
      client = nil
      expect { client = OneviewSDK::Client.new(options) }.to output(
        /Failed to get OneView max api version. Setting to default/).to_stdout_from_any_process
      expect(client.api_version).to eq(200)
    end
  end

  describe '#login' do
    before :each do
      allow_any_instance_of(OneviewSDK::Client).to receive(:login).and_call_original
    end

    it 'gets a token from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return('sessionID' => 'secret789')
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123' }
      client = OneviewSDK::Client.new(options)
      expect(client.token).to eq('secret789')
    end

    it 'tries twice to get a token from the appliance' do
      allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return({})
      options = { url: 'https://oneview.example.com', user: 'Administrator', password: 'secret123', log_level: :debug }
      expect { OneviewSDK::Client.new(options) rescue nil }.to output(/Retrying.../).to_stdout_from_any_process
      options.delete(:log_level)
      expect { OneviewSDK::Client.new(options) }.to raise_error(/Couldn't log into OneView server/)
    end
  end
end