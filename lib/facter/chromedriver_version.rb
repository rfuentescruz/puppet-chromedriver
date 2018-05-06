Facter.add('chromedriver_version') do
  setcode do
    if Facter::Util::Resolution.which('chromedriver')
      version = ''
      IO.popen('chromedriver --version') do |io|
        # Read bytes one by one until newline
        loop do
          version << io.read(1)
          if version.include? "\n"
            break
          end
        end

        # Old chromedriver versions do not support the `--version` flag and
        # will continue to run indefinitely
        unless io.closed?
          Process.kill('KILL', io.pid)
        end
      end
      version.match(%r{\d+\.\d+(\.\d+)?})[0] if version
    end
  end
end
