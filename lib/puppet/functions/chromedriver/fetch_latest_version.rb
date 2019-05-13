require 'open-uri'

Puppet::Functions.create_function(:'chromedriver::fetch_latest_version') do
  dispatch :fetch_latest_version do
    optional_param 'String', :source
  end

  def fetch_latest_version(source = 'https://chromedriver.storage.googleapis.com')
    open("#{source}/LATEST_RELEASE") do |f|
      f.read
    end
  rescue SocketError
    nil
  end
end
