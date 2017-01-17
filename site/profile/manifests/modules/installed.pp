# Code to set installed modules fact
class profile::modules::installed {

  case $::osfamily {
    'Windows': {
      $base_content = ' base_windows,'
      $module_dir   = hiera('puppet::facts_dir::windows')
    }
    default: {
      $base_content = ' base_common,'
      $module_dir   = hiera('puppet::facts_dir::linux')
      mkdir::p { $module_dir: }
    }
  }
  $module_file      = hiera('modules::installed::module_file')
  $module_file_path = "${module_dir}/${module_file}"

  concat { $module_file_path:
    path => $module_file_path,
    mode => '0644'
  }

  concat::fragment{ "module_fragment_${name}":
    target  => $module_file_path,
    order   => '2',
    content => $base_content,
  }

  concat::fragment{ 'module_header':
    target  => $module_file_path,
    content => "---\nmodules: [",
    order   => '1'
  }
  concat::fragment{ 'module_footer':
    target  => $module_file_path,
    content => ']',
    order   => '4'
  }
}
