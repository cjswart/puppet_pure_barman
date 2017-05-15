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
      name   => "postgres@${::fqdn}",
      type   => $facts['pure_postgres_ssh_public_key_type'],
      key    => $facts['pure_postgres_ssh_public_key_key'],
      tag    => "postgres:${pure_barman::barman_server}",
      user   => 'barman',
    }
  }

  Ssh_authorized_key <<| tag == "barman:${pure_barman::barman_server}" |>>

  @@sshkey { "${::fqdn} for ${pure_barman::barman_server}":
    name => $facts['fqdn'],
    type => ecdsa-sha2-nistp256,
    key  => $::sshecdsakey,
    tag  => "postgres:${pure_barman::barman_server}",
  }

  @@sshkey { "${facts['fqdn']}_${facts['networking']['ip']} for ${pure_barman::barman_server}":
    name => $facts['networking']['ip'],
    type => ecdsa-sha2-nistp256,
    key  => $::sshecdsakey,
    tag  => "postgres:${pure_barman::barman_server}",
  }

  if $facts['fqdn'] != $facts['hostname'] {
    @@sshkey { "${facts['fqdn']}_${facts['hostname']} for ${pure_barman::barman_server}":
      name => $facts['hostname'],
      type => ecdsa-sha2-nistp256,
      key  => $::sshecdsakey,
      tag  => "postgres:${pure_barman::barman_server}",
    }
  }

  Sshkey <<| tag == "barman:${pure_barman::barman_server}" |>>
}

