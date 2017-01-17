# Puppet Master role
class role::puppet_master {

#if $::app_tier == 'production' {
  #include profile::aws::key
  #include profile::aws::requirements
  #include profile::aws::ec2_elastic_ip
  #include profile::aws::ec2_instances::nginx
#}
  include profile::puppet::master
  include pe_repo::platform::ubuntu_1204_amd64
  include pe_repo::platform::ubuntu_1404_amd64
  include pe_repo::platform::el_6_x86_64
  include pe_repo::platform::el_7_x86_64
  include pe_repo::platform::windows_x86_64

  #Include all user exported resources in order to ensure they are in the db
  #include profile::users::admins
  #include profile::users::developers
}
