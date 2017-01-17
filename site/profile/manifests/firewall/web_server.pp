class profile::firewall::web_server {
  firewall { '100 allow http access':
    ensure => present,
    dport  => '80',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow https access':
    ensure => present,
    dport  => '443',
    proto  => 'tcp',
    action => 'accept',
  }

}
