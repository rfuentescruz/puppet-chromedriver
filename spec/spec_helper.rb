require 'open-uri'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

begin
  require 'spec_helper_local' if File.file?(File.join(File.dirname(__FILE__), 'spec_helper_local.rb'))
rescue LoadError => loaderror
  warn "Could not require spec_helper_local: #{loaderror.message}"
end

include RspecPuppetFacts

default_facts = {
  puppetversion: Puppet.version,
  facterversion: Facter.version,
}

default_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_facts.yml'))
default_module_facts_path = File.expand_path(File.join(File.dirname(__FILE__), 'default_module_facts.yml'))

if File.exist?(default_facts_path) && File.readable?(default_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_facts_path)))
end

if File.exist?(default_module_facts_path) && File.readable?(default_module_facts_path)
  default_facts.merge!(YAML.safe_load(File.read(default_module_facts_path)))
end

RSpec.configure do |c|
  c.default_facts = default_facts

  c.expect_with :rspec

  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  c.before(:each) do
    allow(OpenURI).to receive(:open_uri)
      .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/LATEST_RELEASE'))
      .and_return('2.11')
  end

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
