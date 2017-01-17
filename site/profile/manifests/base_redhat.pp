# Apply to all Redhat-like nodes
class profile::base_redhat {

  $nameservers  = hiera('resolv_conf::nameservers')
  $domain       = hiera('resolv_conf::domain')
  $minimal_host = hiera('puppet::minimal::host')

  if $::hostname !~ /$minimal_host/ {
    include profile::base::packages_redhat
  }
  require profile::base_common

  $major_release = $::facts['os']['release']['major']

  if $::virtual == 'vmware' and $major_release =~ '7' {
    include profile::openvmtools
  }
  elsif $::virtual == 'vmware' {
    include profile::vmwaretools
  }

# Ensure that puppet commands are in your path when using sudo
  file_line { 'secure_path':
    path  => '/etc/sudoers',
    line  => 'Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin',
    match => 'secure_path'
  }

  #Ensure PE package repo point to current version of PE
    file { 'pe_repo':
      ensure => absent,
      path   => '/etc/yum.repos.d/pe_repo.repo',
    }

  #file_line {'dns1':
  #  ensure => present,
  #  path   => "/etc/sysconfig/network-scripts/ifcfg-${::networking[primary]}",
  #  line   => "DNS1=${nameservers[0]}",
  #  match  => '^DNS1',
  #}
  #file_line {'dns2':
  #    ensure => present,
  #    path   => "/etc/sysconfig/network-scripts/ifcfg-${::networking[primary]}",
  #    line   => "DNS2=${nameservers[1]}",
  #    after  => '^DNS1',
  #    match  => '^DNS2',
  #}
  #file_line {'searchdomain':
  #  ensure => present,
  #  path   => "/etc/sysconfig/network-scripts/ifcfg-${::networking[primary]}",
  #  line   => "DOMAIN='${domain}'",
  #  after  => '^DNS2',
  #}
}
