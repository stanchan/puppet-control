#Installs and configures osquery for Linux
class profile::base::osquery {

  $interval = '86400'
  $hour = '3600'
  $snapshot = true

  class{'osquery':
    settings => {
      'options'    => {
        'config_plugin'          => 'filesystem',
        'host_identifier'        => 'hostname',
        'event_expiry'           => '8600',
        'debug'                  => false,
        'verbose_debug'          => false,
        'database_path'          => '/var/osquery/osquery.db',
        'worker_threads'         => $::processorcount,
        'schedule_splay_percent' => '10',
      },
      'schedule'   => {
        'installed_software_snapshot' => {
          'query'       => 'SELECT * FROM deb_packages;',
          'interval'    => $interval,
          'snapshot'    => $snapshot,
          'description' => 'Display all installed debian software packages'
        },
        'kernel_info'                 => {
          'query'       => 'SELECT * FROM kernel_info;',
          'interval'    => $interval,
          'snapshot'    => $snapshot,
          'version'     => '1.4.5',
          'description' => 'Retrieves information from the current kernel in the target system.',
          'value'       => 'Identify out of date kernels or version drift across your infrastructure'
        },
        'os_version'                  => {
          'query'       => 'SELECT * FROM os_version;',
          'interval'    => $interval,
          'snapshot'    => $snapshot,
          'version'     => '1.4.5',
          'description' => 'Retrieves information from the operating system where osquery is currently running.',
        },
        'osquery_info'                => {
          'query'       => 'SELECT * FROM osquery_info',
          'interval'    => $interval,
          'description' => 'Retrieves info about the running osqueryd process',
        },
        'crontab'                     => {
          'query'       => 'SELECT * FROM crontab;',
          'interval'    => $hour,
          'description' => 'Lists enabled crontabs'
        },
        'running_processes'           => {
          'query'       => 'SELECT * FROM processes;',
          'interval'    => $hour,
          'description' => 'Lists the currently running processes'
        },
        'kernel_modules'              => {
          'query'       => 'SELECT * FROM kernel_modules;',
          'interval'    => $interval,
          'description' => 'Lists kernel modules'
        },
        'file_events'                 => {
          'query'    => 'SELECT * FROM file_events;',
          'interval' => $hour,
          'removed'  => false
        },
        'last_logins'                 => {
          'query'    => 'SELECT * FROM last;',
          'interval' => $hour
        },
        'system_info'                 => {
          'query'       => 'SELECT * FROM system_info;',
          'interval'    => $interval,
          'description' => 'Display information about the system'
        },
        'shell_history_all_users'     => {
          'query'       => 'select users.username, shell_history.command, shell_history.history_file from users join shell_history using(uid);',
          'interval'    => '14400',
          'description' => 'Record shell history for all users on system (instead of just root)'
        },
        'suid_bin'                    => {
          'query'       => 'SELECT * FROM suid_bin;',
          'inteval'     => $hour,
          'description' => 'Setuid binaries'
        },
        'process_envs'                => {
          'query'       => 'SELECT * FROM process_envs;',
          'interval'    => $hour,
          'description' => 'Process environments'
        },
        'users'                       => {
          'query'       => 'SELECT * FROM users;',
          'interval'    => $hour,
          'description' => 'List users'
        },
        'removable_usb_devices'       => {
          'query'       => 'SELECT * FROM usb_devices WHERE removable=1;',
          'interval'    => $hour,
          'description' => 'Lists removable USB devices'
        }
      },
      'file_paths' => {
        'etc'      => [
          '/etc/%%'
        ],
        'binaries' => [
          '/usr/bin/%%',
          'usr/sbin/%%',
          '/bin/%%',
          '/sbin/%%',
          '/usr/local/bin/%%',
          '/usr/local/sbin/%%'
        ]
      }
    }
  }
}
