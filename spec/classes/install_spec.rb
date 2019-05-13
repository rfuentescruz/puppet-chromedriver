require 'spec_helper'

describe 'chromedriver::install' do
  after(:each) { Facter.clear }
  let(:facts) do
    {
      chromedriver_version: nil,
    }
  end

  describe 'when unable to fetch chromedriver versions' do
    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/LATEST_RELEASE'))
        .and_raise(SocketError)
    end

    it { is_expected.to compile.and_raise_error(%r{Unable to get latest chromedriver version}) }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      it { is_expected.to compile }
    end
  end

  describe 'creates required resources' do
    it {
      is_expected.to contain_file('/opt/chromedriver')
        .with_ensure('directory')
    }

    it {
      is_expected.to contain_file('/opt/chromedriver/2.11')
        .with_ensure('directory')
    }

    it {
      is_expected.to contain_file('/opt/chromedriver/2.11/chromedriver')
        .with_mode('0755')
    }

    it {
      is_expected.to contain_file('/usr/local/bin/chromedriver')
        .with_target('/opt/chromedriver/2.11/chromedriver')
    }
  end

  describe 'latest chromedriver' do
    let(:params) do
      {
        version: 'latest',
      }
    end

    describe 'with no chromedriver installed' do
      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.11/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is lower' do
      let(:facts) do
        {
          chromedriver_version: '1.0',
        }
      end

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.11/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version equals latest version' do
      let(:facts) do
        {
          chromedriver_version: '2.11',
        }
      end

      it { is_expected.not_to contain_archive('/tmp/chromedriver-2.11.zip') }
    end
  end

  describe 'specific chromedriver version' do
    let(:params) do
      {
        version: '2.1',
      }
    end

    describe 'with no chromedriver installed' do
      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is lower' do
      let(:facts) do
        {
          chromedriver_version: '1.0',
        }
      end

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version is higher' do
      let(:facts) do
        {
          chromedriver_version: '2.11',
        }
      end

      it {
        is_expected.to contain_archive('/tmp/chromedriver-2.1.zip')
          .with_source('https://chromedriver.storage.googleapis.com/2.1/chromedriver_linux64.zip')
      }
    end

    describe 'when installed chromedriver version equals desired version' do
      let(:facts) do
        {
          chromedriver_version: '2.1',
        }
      end

      it { is_expected.not_to contain_archive('/tmp/chromedriver-2.1.zip') }
    end
  end

  describe 'with custom install directory' do
    let(:params) do
      {
        install_dir: '/tmp/chromedriver',
      }
    end

    it {
      is_expected.to contain_file('/tmp/chromedriver')
        .with_ensure('directory')
    }

    it {
      is_expected.to contain_file('/tmp/chromedriver/2.11')
        .with_ensure('directory')
    }

    it {
      is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
        .with_extract_path('/tmp/chromedriver/2.11')
    }

    it {
      is_expected.to contain_file('/tmp/chromedriver/2.11/chromedriver')
        .with_mode('0755')
    }

    it {
      is_expected.to contain_file('/usr/local/bin/chromedriver')
        .with_target('/tmp/chromedriver/2.11/chromedriver')
    }
  end

  describe 'with custom source' do
    let(:params) do
      {
        source: 'https://some.custom.host',
      }
    end

    describe 'when unable to fetch chromedriver versions' do
      before(:each) do
        allow(OpenURI).to receive(:open_uri)
          .with(URI::HTTPS.build(host: 'some.custom.host', path: '/LATEST_RELEASE'))
          .and_raise(SocketError)
      end

      it { is_expected.to compile.and_raise_error(%r{Unable to get latest chromedriver version}) }
    end
    describe 'on succesfull call' do
      before(:each) do
        allow(OpenURI).to receive(:open_uri)
          .with(URI::HTTPS.build(host: 'some.custom.host', path: '/LATEST_RELEASE'))
          .and_return('2.11')
      end
      describe 'with no chromedriver installed' do
        it {
          is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
            .with_source('https://some.custom.host/2.11/chromedriver_linux64.zip')
        }
      end

      describe 'when installed chromedriver version is lower' do
        let(:facts) do
          {
            chromedriver_version: '1.0',
          }
        end

        it {
          is_expected.to contain_archive('/tmp/chromedriver-2.11.zip')
            .with_source('https://some.custom.host/2.11/chromedriver_linux64.zip')
        }
      end

      describe 'when installed chromedriver version equals latest version' do
        let(:facts) do
          {
            chromedriver_version: '2.11',
          }
        end

        it { is_expected.not_to contain_archive('/tmp/chromedriver-2.11.zip') }
      end
    end
  end

  describe 'with custom link_target' do
    let(:params) do
      {
        link_target: '/some/custom/target',
      }
    end

    it {
      is_expected.to contain_file('/some/custom/target')
        .with_target('/opt/chromedriver/2.11/chromedriver')
    }
  end
end
