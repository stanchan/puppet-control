# Base iptables config and logrotation
class profile::firewall::main {

  include ::firewall
  include profile::firewall::pre
  include profile::firewall::post

  if (str2bool($::purge_iptables)) == false {
    $purge = false
  }
  else {
    $purge = true
  }

  $mangle_purge_real = $::is_mangle ? {
    true    => false,
    default => true
  }

  Firewall {
    before  => Class['profile::firewall::post'],
    require => Class['profile::firewall::pre'],
  }
  firewallchain { ['INPUT:filter:IPv4', 'FORWARD:filter:IPv4', 'OUTPUT:filter:IPv4']:
    purge => $purge,
  }

  firewallchain { ['PREROUTING:nat:IPv4','OUTPUT:nat:IPv4', 'POSTROUTING:nat:IPv4']:
    purge => true,
  }

  firewallchain { ['PREROUTING:mangle:IPv4', 'OUTPUT:mangle:IPv4', 'FORWARD:mangle:IPv4', 'INPUT:mangle:IPv4', 'POSTROUTING:mangle:IPv4']:
    purge => $mangle_purge_real,
  }

  firewallchain { ['PREROUTING:raw:IPv4', 'OUTPUT:raw:IPv4']:
    purge => true,
  }

  # Below is needed in order to send iptables logs to their own file
  # This may be better managed with an rsyslog module, but this works
    file { '/etc/rsyslog.d/25-iptables.conf':
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/profile/base/rsyslog.iptables.conf',
      notify => Service['rsyslog'],
    }

    ensure_resource('service', 'rsyslog', {'ensure' => 'running'})

    logrotate::rule { 'iptables':
      path         => '/var/log/iptables.log',
      rotate       => '5',
      rotate_every => 'week',
      compress     => true,
      copytruncate => true,
    }

}
