# open-vm-tools class
class profile::openvmtools {

  class { '::openvmtools':
    autoupgrade       => true,
  }
}
