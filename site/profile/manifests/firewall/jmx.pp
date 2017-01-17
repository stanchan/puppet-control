# Profile to open default ports for JMX
class profile::firewall::jmx {

  firewall { '100 allow jmx access':
    ensure => present,
    dport  => '9595',
    proto  => 'tcp',
    action => 'accept',
  }

}
