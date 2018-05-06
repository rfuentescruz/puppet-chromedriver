require 'spec_helper'

describe 'chromedriver_version fact' do
  subject { Facter.fact(:chromedriver_version).value }

  after(:each) { Facter.clear }

  describe 'when chromedriver missing' do
    before(:each) do
      allow(Facter::Util::Resolution).to receive(:which)
        .with('chromedriver')
        .and_return(false)
    end

    it { is_expected.to be_nil }
  end

  describe 'when chromedriver is installed' do
    before(:each) do
      allow(Facter::Util::Resolution).to receive(:which)
        .with('chromedriver')
        .and_return('/path/to/chromedriver')

      out = double
      allow(out).to receive(:read).and_return("ChromeDriver 1.2.3 (abc123)\n")
      allow(out).to receive(:closed?).and_return(true)
      allow(IO).to receive(:popen).with('chromedriver --version').and_yield(out)
    end

    it { is_expected.to eq('1.2.3') }
  end
end
