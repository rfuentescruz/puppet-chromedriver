# chromedriver
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include chromedriver
class chromedriver (
  String $version     = $::chromedriver::params::version,
  String $install_dir = $::chromedriver::params::install_dir
) inherits ::chromedriver::params {
  require ::chromedriver::install
}
