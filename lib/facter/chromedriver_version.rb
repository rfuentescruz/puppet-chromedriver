Facter.add('chromedriver_version') do
  setcode do
    if Facter::Util::Resolution.which('chromedriver')
      version = Facter::Util::Resolution.exec('chromedriver --version')
      version.match(%r{\d+\.\d+\.\d+})[0] if version
    end
  end
end
