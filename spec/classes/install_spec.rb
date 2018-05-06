require 'spec_helper'

describe 'chromedriver::install' do
  after(:each) { Facter.clear }
  let(:facts) { { 'chromedriver_version' => nil } }

  describe 'when unable to fetch chromedriver versions' do
    let(:pre_condition) { 'include ::chromedriver' }

    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/'))
        .and_raise(SocketError)
    end

    it { is_expected.to compile.and_raise_error(%r{Unable to get chromedriver versions}) }
  end

  on_supported_os.each do |os, os_facts|
    let(:pre_condition) { 'include ::chromedriver' }

    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  describe 'creates required resources' do
    let(:pre_condition) { 'include ::chromedriver' }

    it {
      is_expected.to contain_file('/opt/chromedriver')
        .with_ensure('directory')
    }

    it {
      is_expected.to contain_file('/usr/local/bin/chromedriver')
        .with_target('/opt/chromedriver/chromedriver')
    }
  end

  describe 'latest chromedriver' do
    let(:pre_condition) do
      'class { "chromedriver": version => "latest" }'
    end

    describe 'with no chromedriver installed' do
      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.11/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is lower' do
      let(:facts) { { 'chromedriver_version' => '1.0' } }

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.11/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version equals latest version' do
      let(:facts) { { 'chromedriver_version' => '2.11' } }

      it { is_expected.not_to contain_archive('/tmp/chromedriver-2.11.zip') }
    end
  end

  describe 'specific chromedriver version' do
    let(:pre_condition) do
      'class { "chromedriver": version => "2.1" }'
    end

    describe 'with no chromedriver installed' do
      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is lower' do
      let(:facts) { { 'chromedriver_version' => '1.0' } }

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is higher' do
      let(:facts) { { 'chromedriver_version' => '2.11' } }

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version equals desired version' do
      let(:facts) { { 'chromedriver_version' => '2.1' } }

      it { is_expected.not_to contain_archive('/tmp/chromedriver-2.1.zip') }
    end
  end

  describe 'with custom install directory' do
    let(:pre_condition) { 'class { "chromedriver": install_dir => "/tmp/chromedriver" }' }

    it {
      is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
        .with_extract_path('/tmp/chromedriver')
    }
  end

  describe 'with invalid version' do
    let(:pre_condition) do
      'class { "chromedriver": version => "0.0" }'
    end

    it { is_expected.to compile.and_raise_error(%r{Invalid version}) }
  end
end
