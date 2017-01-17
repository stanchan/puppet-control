# let other modules register themselves in the motd
define profile::modules::register($content='', $order='3') {
  case $::osfamily {
    'Windows': {
      $module_dir   = hiera('puppet::facts_dir::windows')
    }
    default: {
      $module_dir   = hiera('puppet::facts_dir::linux')
    }
  }
  $module_file      = hiera('modules::installed::module_file')
  $module_file_path = "${module_dir}/${module_file}"

  if $content == '' {
    $body = $name
  } else {
    $body = $content
  }
  concat::fragment{ "module_fragment_${name}":
    target  => $module_file_path,
    order   => $order,
    content => " ${body},"
  }
}
