#Sets sysctl settings on all hosts
class profile::base::sysctl {

  if $::kernelmajversion >= '3.5' {
    $swappiness = '1'
  }
  else {
    $swappiness = '0'
  }

  sysctl { 'vm.swappiness':
    value => $swappiness
  }

}
