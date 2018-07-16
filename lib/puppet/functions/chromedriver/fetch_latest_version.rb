require 'open-uri'

Puppet::Functions.create_function(:'chromedriver::fetch_latest_version') do
  def fetch_latest_version
    open('https://chromedriver.storage.googleapis.com/LATEST_RELEASE') do |f|
      f.read
    end
  rescue SocketError
    nil
  end
end
