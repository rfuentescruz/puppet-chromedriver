require 'spec_helper'

RSpec.describe 'chromedriver::fetch_latest_version' do
  describe 'on successful call' do
    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/LATEST_RELEASE'))
        .and_return('2.11')
    end

    it { is_expected.to run.and_return('2.11') }
    it { is_expected.to run.with_params('https://chromedriver.storage.googleapis.com').and_return('2.11') }
  end

  describe 'on failed call' do
    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/LATEST_RELEASE'))
        .and_raise(SocketError)
    end

    it { is_expected.to run.and_return(nil) }
    it { is_expected.to run.with_params('https://chromedriver.storage.googleapis.com').and_return(nil) }
  end
end
