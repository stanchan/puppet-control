#Fusion Firewall Profile
class profile::firewall::fusion {
  firewall { '100 allow fusion access':
    ensure => present,
    dport  => ['9983', '8984', '8765', '8766', '8769', '8764', '8864'],
    proto  => 'tcp',
    action => 'accept',
  }
}
