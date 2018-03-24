require 'spec_helper'
require 'set'

xml = <<XML
  <?xml version="1.0" encoding="UTF-8"?>
  <ListBucketResult xmlns="http://doc.s3.amazonaws.com/2006-03-01">
    <Name>chromedriver</Name>
    <IsTruncated>false</IsTruncated>
    <Contents>
      <Key>2.11/chromedriver_linux64.zip</Key>
  </Contents>
    <Contents>
      <Key>2.0/chromedriver_linux32.zip</Key>
  </Contents>
    <Contents>
      <Key>2.0/chromedriver_linux64.zip</Key>
  </Contents>
    <Contents>
      <Key>1.0/chromedriver_mac64.zip</Key>
  </Contents>
    <Contents>
      <Key>2.1/chromedriver_linux64.zip</Key>
  </Contents>
  </ListBucketResult>
XML

RSpec.describe 'chromedriver::fetch_versions' do
  describe 'on successful call' do
    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/'))
        .and_return(xml)
    end

    it { is_expected.to run.and_return(['1.0', '2.0', '2.1', '2.11']) }
  end

  describe 'on failed call' do
    before(:each) do
      allow(OpenURI).to receive(:open_uri)
        .with(URI::HTTPS.build(host: 'chromedriver.storage.googleapis.com', path: '/'))
        .and_raise(SocketError)
    end

    it { is_expected.to run.and_return([]) }
  end
end
