# Debian / Ubuntu packages
class profile::base::packages_deb {

  if $::lsbmajdistrelease == '14.04' {
    $ruby         = 'ruby'
    $rubygems     = 'rubygems-integration'
    $add_apt_repo = 'software-properties-common'
    $vmsvc        = "if \$programname == \'vmsvc\' and \$msg contains \'Failed to get vmstats\' then stop\n"
  }
  else {
    $ruby         = 'ruby1.8'
    $rubygems     = 'rubygems'
    $add_apt_repo = 'python-software-properties'
    $vmsvc        = ":msg, contains, \"[ warning] [guestinfo] Failed to get vmstats.\" ~\n"
  }

  package { [
      'apt',
      'ack-grep',
      'aptitude',
      'base-files',
      'build-essential',
      'dnsutils',
      'dpkg',
      'git-core',
      'gnupg',
      'libgnutls26',
      'libjpeg62',
      'libjpeg8',
      'libnss3',
      'libpng12-0',
      'libyajl-dev',
      'man-db',
      'netcat6',
      'perl-doc',
      $add_apt_repo,
      $ruby,
      'ruby-dev',
      $rubygems,
      'sg3-utils',
      'tcpflow',
      'util-linux',
      'vim',
      ]:
      ensure => latest;
      }

  ensure_resource('package', [ 'libssl-dev', 'ca-certificates'], {'ensure' => 'present'})

  package { [
    'resolvconf',
    'ppp',
    ]:
    ensure => purged,
  }

}
