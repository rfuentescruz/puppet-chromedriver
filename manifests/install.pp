# chromedriver::install
#
# @summary Installs chromedriver
#
# @example
#   include chromedriver::install
class chromedriver::install (
  String               $version     = $::chromedriver::params::version,
  Stdlib::Absolutepath $install_dir = $::chromedriver::params::install_dir,
  Stdlib::Absolutepath $link_target = $::chromedriver::params::link_target,
  Stdlib::Httpurl      $source      = $::chromedriver::params::source,
) inherits ::chromedriver::params {

  $packages = ['libgconf2-dev', 'libxi-dev', 'unzip', 'libnss3-dev']
  ensure_packages($packages, {'ensure' => 'present'})

  $latest = chromedriver::fetch_latest_version($source)

  if !$latest {
    fail('Unable to get latest chromedriver version')
  }

  if $version == 'latest' {
    $desired_version = $latest
  } else {
    $desired_version = $version
  }

  if !$facts['chromedriver_version'] or (versioncmp($desired_version, $facts['chromedriver_version']) != 0) {
    $version_dir = "${install_dir}/${desired_version}"

    file { $version_dir:
      ensure  => 'directory',
      require => File[$install_dir],
    } -> archive { "/tmp/chromedriver-${desired_version}.zip":
      ensure       => 'present',
      source       => "${source}/${desired_version}/chromedriver_${platform}${arch}.zip", #lint:ignore:variable_scope
      extract      => true,
      extract_path => $version_dir,
      cleanup      => true,
      creates      => "${version_dir}/chromedriver",
      require      => Package['unzip'],
    } -> file { "${version_dir}/chromedriver":
      mode   => '0755',
    } -> file { $link_target:
      ensure => 'link',
      target => "${version_dir}/chromedriver",
    }
  }

  file { $install_dir:
    ensure => 'directory',
  }
}
