#Configures puppet agent nodes
class profile::puppet::agent {

  puppetconf::agent { 'splay':
    value     => true,
    conf_path => $::puppet_config,
  }

  if $::app_tier != 'test'{
    puppetconf::agent { 'environment':
      value     => $::app_tier,
      conf_path => $::puppet_config
    }
  }
}
