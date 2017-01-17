#Applies our puppet master configurations
class profile::puppet::master {

  include profile::firewall::main
  include ::pe_install_ps1

  $ruby_gems       = hiera('puppetserver::gems')
  $merge_behavior  = 'deeper'
  $eyaml           = true
  $eyaml_extension = 'yaml'

# Puppetserver Gems
  package { $ruby_gems:
    ensure   => installed,
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver']
  }

  limits::fragment {
    'pe-puppet/hard/nofile':
      value => '65535';
  }

  firewall { '100 allow https access':
    ensure => present,
    dport  => '443',
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '100 allow puppet access':
    ensure => present,
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }
  firewall { '100 allow mcollective access':
    ensure => present,
    dport  => '61613',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow PE Orchestrator':
    ensure => present,
    dport  => '8142',
    proto  => 'tcp',
    action => 'accept'
  }

  firewall { '101 allow db dashboard access':
    ensure => present,
    dport  => '8080',
    proto  => 'tcp',
    action => 'accept'
  }

  firewall { '102 allow authenticated db api access':
    ensure => present,
    dport  => '8081',
    proto  => 'tcp',
    action => 'accept'
  }

  firewall { '103 allow rbac api access':
    ensure => present,
    dport  => '4433',
    proto  => 'tcp',
    action => 'accept'
  }

  profile::modules::register {'puppet_master':}

  class { 'hiera':
    hierarchy       => [
      'nodes/%{clientcert}',
      'app_tier/%{app_tier}',
      'location/%{location}',
      'common',
      ],
    datadir         => '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
    merge_behavior  => $merge_behavior,
    provider        => 'puppetserver_gem',
    eyaml           => $eyaml,
    eyaml_extension => 'yaml',
    manage_package  => true,
  }

  firewall { '100 allow webhook access':
    ensure => present,
    dport  => '8170',
    proto  => 'tcp',
    action => 'accept',
  }

  if $::app_tier != 'test'{
    cron { 'pe_dumpall':
      command  => "sudo -u pe-postgres /opt/puppet/bin/pg_dumpall > puppet-master-${::app_tier}/dumpall_`/bin/date +\'%Y%m%d%H%M\'`\"",
      user     => 'pe-postgres',
      hour     => '4',
      minute   => '30',
      monthday => '15',
    }
  }
}
