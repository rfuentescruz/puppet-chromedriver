require 'spec_helper'

describe 'chromedriver::params' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  describe 'on linux 32-bit' do
    let(:facts) do
      {
        'osfamily'     => 'Debian',
        'architecture' => 'x86',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{Unsupported platform}) }
  end

  describe 'on darwin 32-bit' do
    let(:facts) do
      {
        'osfamily'     => 'Darwin',
        'architecture' => 'x86',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{Unsupported platform}) }
  end
end
