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


# == Class: pure_barman::client_config
#
# Configure a postgres database server to be backed up by a barman server
class pure_barman::client_config
(
)
{

  file { "${pure_postgres::pg_bin_dir}/pure_barman_releasenotes.txt":
    ensure => 'file',
    source => 'puppet:///modules/pure_barman/releasenotes.txt',
    owner  => $pure_barman::barman_user,
    group  => $pure_barman::barman_group,
    mode   => '0750',
  }

  #Exported resource of configuration file for client specific config on barman server
  #This is generated on barman client and applied on barman server (pure_barman::config)
  @@file { "${pure_barman::params::barman_conf}/${::fqdn}.conf":
    ensure  => 'present',
    owner   => $pure_barman::params::barman_user,
    group   => $pure_barman::params::barman_group,
    mode    => '0750',
    content => epp('pure_barman/barman-client.epp'),
    tag     => $pure_barman::client::barman_server,
  }

  @@file {"${pure_barman::params::barman_data}/${::fqdn}":
    ensure => 'directory',
    owner  => $pure_barman::params::barman_user,
    group  => $pure_barman::params::barman_group,
    mode   => '0755',
    tag    => $pure_barman::client::barman_server,
  }

  #Also create exported resources for client specific subfolders on barman server
  #This is generated on the clients and applied on the barman server (pure_barman::config)
  $pure_barman::params::barman_client_folders.each | String $subdir | {
    @@file {"${pure_barman::params::barman_data}/${::fqdn}/${subdir}":
      ensure => 'directory',
      owner  => $pure_barman::params::barman_user,
      group  => $pure_barman::params::barman_group,
      mode   => '0755',
      tag    => $pure_barman::client::barman_server,
    }
  }

  #On first run of a replicated cluster node, pure_postgres::config isn't run and conf.d folder folder isn't defined / created yet.
  #In that case, skip editing config files and similar stuff.
  if defined(File[ "${pure_postgres::params::pg_etc_dir}/conf.d" ]) {
    file { "${pure_postgres::params::pg_etc_dir}/conf.d/backup.conf":
      ensure  => 'present',
      owner   => $pure_postgres::params::postgres_user,
      group   => $pure_postgres::params::postgres_group,
      mode    => '0750',
      content => epp('pure_barman/backup.epp'),
      notify  => Class['pure_postgres::restart'],
    }

    #All the ssh stuff to be done on barman clients
    include pure_barman::client_ssh

    #Add pg_hba entry for barman server
    Pure_postgres::Pg_hba <<| tag == $pure_barman::client::barman_server |>>

    #If this file is already defined (like by repmgr role) then don't define it from barman role.

    if ! defined(File[ "${pure_postgres::params::pg_etc_dir}/conf.d/wal.conf" ]) {
      file { "${pure_postgres::params::pg_etc_dir}/conf.d/wal.conf":
        ensure  => file,
        content => epp('pure_barman/wal.epp'),
        owner   => $pure_postgres::params::postgres_user,
        group   => $pure_postgres::params::postgres_group,
        mode    => '0640',
        require => File["${pure_postgres::params::pg_etc_dir}/conf.d"],
        replace => false,
        notify  => Class['pure_postgres::reload'],
      }
    }
  }
}

