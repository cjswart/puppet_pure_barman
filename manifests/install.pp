# == Class: pure_repmgr::install
#
# Installs repmgr from pure repo
class pure_repmgr::install
(
  $pg_data_dir = $pure_repmgr::pg_data_dir,
  $pg_xlog_dir = $pure_repmgr::pg_xlog_dir,
) inherits pure_repmgr
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

  if $facts['pure_cloud_nodeid'] {

    #By default don't initdb. For intial master, config will include initdb class himself.
    class { 'pure_postgres':
      do_initdb   => false,
      pg_data_dir => $pg_data_dir,
      pg_xlog_dir => $pg_xlog_dir,
      pg_ssl_cn   => $pure_repmgr::dnsname,
    }

    if $pure_repmgr::cluster_logger {
      include pure_repmgr::cluster_logger
    }
  }
  else {
    include pure_postgres::postgres_user
  }

}

