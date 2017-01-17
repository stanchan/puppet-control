# Ports for snmp access
class profile::firewall::snmp {
  firewall { '100 allow snmp port 161 access':
    ensure => present,
    dport  => '161',
    proto  => 'udp',
    action => 'accept',
  }

  firewall { '100 allow snmp port 162 access':
    ensure => present,
    dport  => '162',
    proto  => 'udp',
    action => 'accept',
  }

}
