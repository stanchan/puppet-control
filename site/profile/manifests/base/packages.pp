# Packages that we want to ensure on all osfamilies
class profile::base::packages {

  if $::osfamily == 'RedHat' {
    require ::epel
  }
  if $::operatingsystemmajrelease == '7' {
    $procps_real = 'procps-ng'
  }
  else {
    $procps_real = 'procps'
  }

    package { [
        'bash',
        'bash-completion',
        'coreutils',
        'curl',
        'dstat',
        'ethtool',
        'gdb',
        'gzip',
        'htop',
        'iftop',
        'iotop',
        'ipmitool',
        'lsof',
        'mlocate',
        'ngrep',
        'nscd',
        'openssl',
        'parted',
        'passwd',
        'patch',
        'pigz',
        $procps_real,
        'psmisc',
        'pv',
        'rsync',
        'screen',
        'strace',
        'sysfsutils',
        'sysstat',
        'tcpdump',
        'telnet',
        'tmux',
        'traceroute',
        'unzip',
      ]:
      ensure => latest;
  }

  if ! defined(Package['wget']) {
      package { 'wget':
          ensure => latest,
      }
  }

}
