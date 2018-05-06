require 'nokogiri'
require 'open-uri'
require 'set'

Puppet::Functions.create_function(:'chromedriver::fetch_versions') do
  def fetch_versions
    versions = SortedSet.new []

    begin
      doc = Nokogiri::XML(open('https://chromedriver.storage.googleapis.com/'))
      doc.remove_namespaces!
      items = doc.xpath('//Contents/Key/text()')
    rescue
      items = []
    end

    items.each do |i|
      match = %r{^(\d+\.\d+)\/}.match(i)
      if match then versions.add(match[1]) end
    end
    versions = versions.sort_by { |v| Gem::Version.new(v) }
    versions.to_a
  end
end
