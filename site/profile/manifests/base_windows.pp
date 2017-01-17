# Documentation
class profile::base_windows {

  include profile::nxlog
  include profile::puppet::agent
  include profile::sensu::subscriptions::core_windows
  include profile::grafana::api::add_dashboard
  include profile::modules::installed

  $puppet_version = hiera('puppet::agent::version')

  class {'::puppet_agent':
    package_version => $puppet_version,
  }

}
