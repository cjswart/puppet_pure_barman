# == Class: pure_barman::install
#
# Installs barman from pure repo
class pure_barman::install
(
)
{

  package {$pure_barman::params::barman_package:
    ensure => 'installed',
  } ->

  file { '/usr/local/bin/barman':
    ensure => '/usr/pgpure/barman/bin/barman',
  }

  file { $pure_barman::params::barman_data_tree:
    ensure => directory,
    owner  => $pure_barman::params::barman_user,
    group  => $pure_barman::params::barman_group,
    mode   => '0750',
  }

}

