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

xml = <<XML
  <?xml version="1.0" encoding="UTF-8"?>
  <ListBucketResult xmlns="http://doc.s3.amazonaws.com/2006-03-01">
    <Contents>
      <Key>2.11/chromedriver_linux64.zip</Key>
    </Contents>
    <Contents>
      <Key>2.1/chromedriver_linux64.zip</Key>
   </Contents>
  </ListBucketResult>
XML

RSpec.configure do |c|
  c.default_facts = default_facts

  c.expect_with :rspec

  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  c.before(:each) do
    allow(OpenURI).to receive(:open_uri)
      .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/'))
      .and_return(xml)
  end

  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
