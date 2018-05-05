# chromedriver
#
# Puppet module for `chromedriver`
#
# @example
#   include chromedriver
class chromedriver (
  String $version     = $::chromedriver::params::version,
  String $install_dir = $::chromedriver::params::install_dir,
) inherits ::chromedriver::params {

  include ::chromedriver::install

  package { 'nokogiri':
    ensure   => 'present',
    provider => 'puppet_gem',
    before   => Class['::chromedriver::install'],
  }
}
