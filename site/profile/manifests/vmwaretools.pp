# vmware tools class
class profile::vmwaretools {

  $packages = ['open-vm-tools', 'open-vm-tools-lts-trusty']
  package { $packages :
    ensure => absent,
  }

  class { 'vmwaretools':
    autoupgrade => true,
    reposerver  => 'https://packages.vmware.com',
    require     => [ Package['open-vm-tools'], Package['open-vm-tools-lts-trusty'] ]
  }

}
