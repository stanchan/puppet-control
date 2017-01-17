#Configures msgpack on puppet agent nodes
class profile::puppet::msgpack {
  $version = hiera('msgpack::version')

  exec { 'msgpack_install':
    command => "/opt/puppetlabs/puppet/bin/gem install msgpack -v ${version}",
    creates => "/opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/gems/msgpack-${version}"
  }

  puppetconf::agent { 'preferred_serialization_format':
    value     => 'msgpack',
    conf_path => $::puppet_config,
  }

}
