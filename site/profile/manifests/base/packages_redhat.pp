# Base packages for RedHat family OS
class profile::base::packages_redhat {
  require ::epel

  if $::operatingsystemmajrelease == '7' {
    $man_real                 = 'man-pages'
    $util_linux_real          = 'util-linux'
  }
  else {
    $man_real                 = 'man'
    $util_linux_real          = 'util-linux-ng'
  }

  package { [
    'bc',
    'bind-utils',
    'gcc-c++',
    'git',
    $man_real,
    'ruby',
    'ruby-devel',
    'rubygems',
    $util_linux_real,
    'vim-enhanced',
  ]:
      ensure => latest;
  }

  ensure_resource('package', [ 'gcc' ], {'ensure' => 'present'})

  if $::operatingsystemmajrelease == '6' {
    package { 'yum-plugin-security': ensure => latest }

    cron { 'security_updates':
      user    => 'root',
      command => 'yum update-minimal --security -y',
      hour    => '12',
      minute  => '12',
    }
  }
  elsif $::operatingsystemmajrelease == '7'{
    package { 'yum-cron':
      ensure => present,
    }
    file_line { 'update_cmd':
      path   => '/etc/yum/yum-cron.conf',
      line   => 'update_cmd = security',
      match  => 'update_cmd',
      notify => Service['yum-cron']
    }
    file_line { 'apply_updates':
      path   => '/etc/yum/yum-cron.conf',
      line   => 'apply_updates = yes',
      match  => 'apply_updates',
      notify => Service['yum-cron']
    }
    service { 'yum-cron':
      ensure     => running,
      enable     => true,
      hasrestart => true,
    }
  }

}
