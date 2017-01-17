# Base sudo Config
class profile::base::sudo {

  $purge = hiera('base::purge_sudoers')
  $replace = hiera('base::replace_sudoers')

  class { 'sudo':
    purge               => $purge,
    config_file_replace => $replace,
  }

}
