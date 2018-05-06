# chromedriver::install
#
# @summary Installs chromedriver
#
# @example
#   include chromedriver::install
class chromedriver::install {
  include ::chromedriver::params

  $packages = ['libgconf2-dev', 'libxi-dev', 'unzip', 'libnss3-dev']
  package { $packages:
    ensure => 'present',
  }

  $versions = chromedriver::fetch_versions()
  
  if empty($versions) {
    fail('Unable to get chromedriver versions')
  }

  if $::chromedriver::version == 'latest' {
    $desired_version = $versions[-1]
  } else {
    $desired_version = $::chromedriver::version
  }

  if !($desired_version in $versions) {
    fail("Invalid version ${desired_version}. Supported versions are ${versions}")
  }

  $platform = "${::chromedriver::params::platform}${::chromedriver::params::arch}"

  if !$facts['chromedriver_version'] or (versioncmp($desired_version, $facts['chromedriver_version']) != 0) {
    archive { '/tmp/chromedriver.zip':
      ensure       => 'present',
      source       => "${::chromedriver::params::source}/${desired_version}/chromedriver_${platform}.zip",

      extract      => true,
      extract_path => $::chromedriver::install_dir,
      creates      => "${::chromedriver::install_dir}/chromedriver",

      before       => File['/usr/local/bin/chromedriver'],
      require      => [
        File[$::chromedriver::install_dir],
        Package['unzip'],
      ],
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
