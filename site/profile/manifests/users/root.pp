#Linux root user
class profile::users::root {

  $purge_ssh_keys = hiera('ssh::purge_ssh_keys', true)

  case $::osfamily {
    'Debian': { $password = '!' }
    'Redhat': { $password = '!' }
    default: { $password = '' }
  }

  user { 'root':
    ensure         => present,
    comment        => 'root',
    uid            => '0',
    gid            => '0',
    home           => '/root',
    password       => $password,
    purge_ssh_keys => $purge_ssh_keys,
    shell          => '/bin/bash',
  }

}
