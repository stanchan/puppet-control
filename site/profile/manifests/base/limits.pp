# Base limits
class profile::base::limits {

  limits::fragment {
    '*/-/nofile':
      value => '65536';
    'www-data/-/nofile':
      value => 'unlimited';
    'root/-/nofile':
      value => undef;
  }

}
