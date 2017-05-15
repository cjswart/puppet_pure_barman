# == Class: pure_barman::install
#
# Installs barman from pure repo
class pure_barman::install
(
  $pg_data_dir = $pure_repmgr::pg_data_dir,
  $pg_xlog_dir = $pure_repmgr::pg_xlog_dir,
)
{

  package {$pure_barman::params::barman_package:
    ensure => 'installed',
  }

  file { $pure_barman::params::barman_data_tree:
    ensure => 'directory',
    owner  => 'barman',
    group  => 'barman',
    mode   => '0750',
  }

}

