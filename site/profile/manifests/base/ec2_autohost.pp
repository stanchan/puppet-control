#Sets hostname on EC2 instances
class profile::base::ec2_autohost {

  $host = regsubst($::clientcert, '\..*', '')

  if $facts['ec2_metadata'] {
    host { $::clientcert:
      ensure => present,
      alias  => $host,
      ip     => $::ipaddress
    }

    file { 'myhost':
      path    => '/etc/hostname',
      content => $host
    }

    if $::osfamily == 'Debian' {
      exec{'myhost':
        command     => '/usr/sbin/service hostname start',
        subscribe   => File['myhost'],
        refreshonly => true
      }
    }
    if $::osfamily == 'RedHat'{
      file { '/etc/dhcp/dhclient.d/ntp.sh':
        mode => '0622'
      }

      file_line { 'networking':
        path  => '/etc/sysconfig/network',
        line  => "HOSTNAME=${host}",
        match => 'HOSTNAME'
      }->

      file_line {'cloudconfig':
        path => '/etc/cloud/cloud.cfg',
        line => 'preserve_hostname: true',
      }
      # if $::fqdn != $::clientcert {
      #   exec{'reboot':
      #     command => '/sbin/reboot',
      #   }
      # }
    }
  }

}
