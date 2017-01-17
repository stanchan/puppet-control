# Provides the ability to instantly make a node be in noop via the Node Classifier
class profile::puppet::noop {

  ini_setting { 'puppet.conf agent:noop':
    ensure  => absent,
    path    => "${::settings::confdir}/puppet.conf",
    section => 'agent',
    setting => 'noop',
    noop    => false,
  }

}
