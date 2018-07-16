# chromedriver::install
#
# @summary Installs chromedriver
#
# @example
#   include chromedriver::install
class chromedriver::install {
  include ::chromedriver::params

  $packages = ['libgconf2-dev', 'libxi-dev', 'unzip', 'libnss3-dev']
  ensure_packages($packages, {'ensure' => 'present'})

  $latest = chromedriver::fetch_latest_version()

  if !$latest {
    fail('Unable to get latest chromedriver version')
  }

  if $::chromedriver::version == 'latest' {
    $desired_version = $latest
  } else {
    $desired_version = $::chromedriver::version
  }

  $platform = "${::chromedriver::params::platform}${::chromedriver::params::arch}"

  if !$facts['chromedriver_version'] or (versioncmp($desired_version, $facts['chromedriver_version']) != 0) {
    archive { "/tmp/chromedriver-${desired_version}.zip":
      ensure       => 'present',
      source       => "${::chromedriver::params::source}/${desired_version}/chromedriver_${platform}.zip",

      extract      => true,
      extract_path => $::chromedriver::install_dir,
      cleanup      => true,

      before       => File['/usr/local/bin/chromedriver'],
      require      => [
        File[$::chromedriver::install_dir],
        Package['unzip'],
      ],
    } ~> file { "${::chromedriver::install_dir}/chromedriver":
      mode   => '0755',
    }
  }

  file { $::chromedriver::install_dir:
    ensure => 'directory',
  }

  file { '/usr/local/bin/chromedriver':
    ensure => 'link',
    target => "${::chromedriver::install_dir}/chromedriver",
  }
}
