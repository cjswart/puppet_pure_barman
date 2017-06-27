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

# == Class: pure_barman::client::ssh
#
# Configure barman ssh keys from barman server on a barman client
# and export barman client ssh resources for a server
class pure_barman::client::ssh
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

  if ! defined(Class['pure_postgres::config::ssh']) {
    class { 'pure_postgres::ssh':
      tags => [ pure_barman::client::barman_server, ],
    }
  }

}

