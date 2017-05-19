# == Class: pure_barman::client_ssh
#
# Configure barman ssh keys from barman server on a barman client
# and export barman client ssh resources for a server
class pure_barman::client_ssh
(
)
{

  if $facts['pure_postgres_ssh_public_key_key'] {
    @@ssh_authorized_key { "postgres@${::fqdn} for barman":
      ensure => present,
      type   => $facts['pure_postgres_ssh_public_key_type'],
      key    => $facts['pure_postgres_ssh_public_key_key'],
      tag    => "postgres:${pure_barman::client::barman_server}",
      user   => 'barman',
    }
  }

  Ssh_authorized_key <<| tag == "barman:${pure_barman::client::barman_server}" |>>

  if ! defined(Class['pure_postgres::ssh']) {
    class { 'pure_postgres::ssh':
      tags => [ pure_barman::client::barman_server, ],
    }
  }

}

