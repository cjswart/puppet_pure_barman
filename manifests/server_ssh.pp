# Copyright (C) 2017 Collaboration of KPN and Splendid Data 
#
# This file is part of puppet_pure_barman.
#
# puppet_pure_barman is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# puppet_pure_barman is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with puppet_pure_barman.  If not, see <http://www.gnu.org/licenses/>.

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
    tag  => $::fqdn,
  }

  @@sshkey { "${facts['fqdn']}_${facts['networking']['ip']}":
    name => $facts['networking']['ip'],
    type => ecdsa-sha2-nistp256,
    key  => $::sshecdsakey,
    tag  => $::fqdn,
  }

  if $facts['fqdn'] != $facts['hostname'] {
    @@sshkey { "${facts['fqdn']}_${facts['hostname']}":
      name => $facts['hostname'],
      type => ecdsa-sha2-nistp256,
      key  => $::sshecdsakey,
      tag  => $::fqdn,
    }
  }

  Sshkey <<| tag == $::fqdn |>>

}

