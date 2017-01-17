# Ending rules for iptables
class profile::firewall::post {

  firewall { '899 drop broadcast':
    action   => 'drop',
    dst_type => 'BROADCAST',
    proto    => 'all',
    before   => undef
  }

  firewall { '900 INPUT denies get logged':
    jump       => 'LOG',
    log_level  => '4',
    log_prefix => 'iptables denied: ',
    proto      => 'all',
    before     => undef,
    limit      => '30/min'
  }

  firewall { '999 drop all':
    proto  => 'all',
    action => 'drop',
    before => undef,
  }

}
