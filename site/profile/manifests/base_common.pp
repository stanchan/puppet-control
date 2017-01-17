# Things we want on all linux nodes
class profile::base_common {
  unless $::app_tier {
    fail("app_tier should be set for ${::clientcert}")
  }

  $puppet_version = hiera('puppet::agent::version')
  $minimal_host   = hiera('puppet::minimal::host')

  if ($::security_server != true) or ($::hostname !~ /$minimal_host/) {
    include profile::firewall::main
  }

  if $::ec2_metadata {
    include profile::base::ec2_autohost
  }

  if $::hostname !~ /$minimal_host/ {
    include profile::base::limits
    include profile::base::packages
    include profile::base::sudo
    include profile::base::sysctl
    #include profile::ssh
    #include profile::users::admins
    include profile::users::root
  }

  include ntp
  include profile::base::osquery
  include profile::puppet::noop
  include profile::puppet::msgpack
  include profile::puppet::agent
  include profile::modules::installed

  if $facts['ec2_metadata'] == undef {
    include resolv_conf
  }

  case $::osfamily {
    'RedHat': { $timezone = 'UTC'}
    'Debian': { $timezone = 'Etc/UTC'}
    default: { $timezone = 'UTC'}
  }
  class { 'timezone':
    timezone => $timezone,
  }

  # Commenting out to stop triggering apt-update on every run
  # class {'::puppet_agent':
  #   package_version => $puppet_version,
  # }

}
