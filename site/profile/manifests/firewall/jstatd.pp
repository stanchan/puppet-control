# Profile to open default ports for jstatd
class profile::firewall::jstatd {

  firewall { '100 allow jstatd access':
    ensure => present,
    dport  => '1099',
    proto  => 'tcp',
    action => 'accept',
  }

}
