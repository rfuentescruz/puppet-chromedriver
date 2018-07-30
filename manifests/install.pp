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
    $version_dir = "${::chromedriver::install_dir}/${desired_version}"

    file { $version_dir:
      ensure  => 'directory',
      require => File[$::chromedriver::install_dir],
    } -> archive { "/tmp/chromedriver-${desired_version}.zip":
      ensure       => 'present',
      source       => "${::chromedriver::params::source}/${desired_version}/chromedriver_${platform}.zip",

      extract      => true,
      extract_path => $version_dir,
      cleanup      => true,
      creates      => "${version_dir}/chromedriver",

      require      => Package['unzip'],
    } -> file { "${version_dir}/chromedriver":
      mode   => '0755',
    } -> file { '/usr/local/bin/chromedriver':
      ensure => 'link',
      target => "${version_dir}/chromedriver",
    }
  }

  file { $::chromedriver::install_dir:
    ensure => 'directory',
  }
}
