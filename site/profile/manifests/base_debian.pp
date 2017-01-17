# Apply to all debian-like nodes
class profile::base_debian {

  $minimal_host = hiera('puppet::minimal_puppet')

  if $::hostname !~ /$minimal_host/ {
    include apt
    include unattended_upgrades
    include profile::base::packages_deb
  }

  if $::virtual == 'vmware' and $::lsbmajdistrelease == '14.04' {
    include profile::openvmtools
  }
  elsif $::virtual == 'vmware' {
    include profile::vmwaretools
  }

  if $::lsbmajdistrelease == '14.04' {
    $vmsvc = "if \$programname == \'vmsvc\' and \$msg contains \'Failed to get vmstats\' then stop\n"
  }
  else {
    $vmsvc = ":msg, contains, \"[ warning] [guestinfo] Failed to get vmstats.\" ~\n"
  }

  user { 'ubuntu':
    ensure => absent,
  }

  file { '/usr/local/sbin/kernel_purge':
    ensure => present,
    owner  => 'root',
    group  => 'adm',
    mode   => '0750',
    source => 'puppet:///modules/profile/base/debian/purge-old-kernels',
  }

  cron { 'kernel_purge':
    command     => 'kernel_purge >/dev/null 2>&1',
    user        => 'root',
    minute      => '45',
    hour        => '23',
    weekday     => 'Tuesday',
    environment => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/puppetlabs/bin'
  }

  file { '/etc/rsyslog.d/40-discard.conf':
    owner   => 'root',
    group   => 'root',
    content => $vmsvc,
    notify  => Service['rsyslog']
  }
  ensure_resource('service', 'rsyslog', {'ensure' => 'running'})

  file { '/etc/rsyslog.d/50-default.conf':
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/profile/base/debian/rsyslog.50-default.conf',
    notify => Service['rsyslog']
  }
}
