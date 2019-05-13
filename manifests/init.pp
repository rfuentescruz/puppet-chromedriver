# chromedriver
#
# Puppet module for `chromedriver`
#
# @example
#   include chromedriver
class chromedriver (
  String               $version     = $::chromedriver::params::version,
  Stdlib::Absolutepath $install_dir = $::chromedriver::params::install_dir,
  Stdlib::Absolutepath $link_target = $::chromedriver::params::link_target,
  Stdlib::Httpurl      $source      = $::chromedriver::params::source,
) inherits ::chromedriver::params {

  class { '::chromedriver::install':
    version     => $version,
    install_dir => $install_dir,
    link_target => $link_target,
    source      => $source,
  }
}
