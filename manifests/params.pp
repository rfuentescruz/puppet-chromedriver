# chromedriver::params
#
# @example
#   include chromedriver::params
class chromedriver::params {
  $version = 'latest'

  $install_dir = '/opt/chromedriver'

  if $facts['architecture'] == 'amd64' or $facts['architecture'] == 'x86_64' {
    $arch = '64'
  } else {
    $arch = '32'
  }

  case $facts['osfamily'] {
    /^(D|d)arwin$/: { $platform = 'mac' }
    'windows':      { $platform = 'windows' }
    default:        { $platform = 'linux' }
  }

  $supported_platforms = ['linux64', 'windows32', 'mac64']

  if !("${platform}${arch}" in $supported_platforms) {
    fail("Unsupported platform ${platform}${arch}")
  }

  $source = 'https://chromedriver.storage.googleapis.com'
  $link_target = '/usr/local/bin/chromedriver'
}
