# == Class: pure_barman::server_ssh
#
# Configure barman ssh keys from barman clients on a barman server
# and export barman server ssh resources for clients
class pure_barman::server_ssh
(
)
{

  if $facts['pure_barman_ssh_public_key_key'] {
    @@ssh_authorized_key { $facts['pure_barman_ssh_public_key_comment']:
      ensure => present,
      type   => $facts['pure_barman_ssh_public_key_type'],
      key    => $facts['pure_barman_ssh_public_key_key'],
      tag    => "barman:${::fqdn}",
      user   => 'postgres',
    }
  }

  Ssh_authorized_key <<| tag == "postgres:${::fqdn}" |>>

  @@sshkey { $facts['fqdn']:
    type => ecdsa-sha2-nistp256,
    key  => $::sshecdsakey,
    tag  => "barman:${::fqdn}",
  }

  @@sshkey { "${facts['fqdn']}_${facts['networking']['ip']}":
    name => $facts['networking']['ip'],
    type => ecdsa-sha2-nistp256,
    key  => $::sshecdsakey,
    tag  => "barman:${::fqdn}",
  }

  if $facts['fqdn'] != $facts['hostname'] {
    @@sshkey { "${facts['fqdn']}_${facts['hostname']}":
      name => $facts['hostname'],
      type => ecdsa-sha2-nistp256,
      key  => $::sshecdsakey,
      tag  => "barman:${::fqdn}",
    }
  }

  Sshkey <<| tag == "postgres:${::fqdn}" |>>

}

