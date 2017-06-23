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

# == Class: pure_barman::config
#
# Configure a barman server to backup postgres database nodes
class pure_barman::config
(
)
{

  file { "${pure_barman::barman_bin_dir}/pure_barman_releasenotes.txt":
    ensure  => 'file',
    source => 'puppet:///modules/pure_barman/releasenotes.txt',
    owner   => $pure_barman::barman_user,
    group   => $pure_barman::barman_group,
    mode    => '0750',
  }

  #Create facter folders where facts script will end up
  if ! defined(File['/etc/facter/facts.d']) {
    file { [  '/etc/facter', '/etc/facter/facts.d' ]:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  #create facts script to add barman ssh keys to facts
  file { '/etc/facter/facts.d/pure_barman_facts.sh':
    ensure  => file,
    content => epp('pure_barman/pure_barman_facts.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/facter/facts.d'],
  }

  #Create the folder for the configuration files
  file { $pure_barman::params::barman_conf_tree:
    ensure => 'directory',
    owner  => $pure_barman::params::barman_user,
    group  => $pure_barman::params::barman_group,
    mode   => '0755',
  }

  #Barman clients export client configuration files aswell as folder definitions for the client backup data
  #Lets create those resources
  File <<| tag == $::fqdn |>>

  #Create cron job for barman
  cron { 'backup':
    command => '/usr/pgpure/barman/bin/barman backup all > /var/log/pgpure/barman/backup.log',
    user    => 'barman',
    hour    => 23,
    minute  => 0,
  }

  #Setup SSH access requirements
  include pure_barman::server_ssh

  #Create exported resource for pg_hba entry for barman access on postgres database server.
  #This resource is exported by barman server and applied on all postgres database servers.
  @@pure_postgres::pg_hba {"pg_hba entry for barman from ${facts['networking']['ip']}":
    database        => 'postgres,replication',
    method          => 'trust',
    state           => 'present',
    source          => "${facts['networking']['ip']}/32",
    connection_type => 'host',
    user            => 'postgres',
    notify          => Class['pure_postgres::reload'],
    tag             => $::fqdn,
  }

  #Apply all the barman client config files resources as exported by barman clients (pure_barman::client_config)
  File <<| tag == "barman_client_config:${::fqdn}" |>>

  #Create all the barman client folders as exported by barman clients (pure_barman::client_config)
  File <<| tag == "barman_datafolder:${::fqdn}" |>>

  file { '/etc/barman':
    ensure  => directory,
    owner   => $pure_barman::params::barman_user,
    group   => $pure_barman::params::barman_group,
    mode    => '0640',
  }

  file { '/etc/barman/barman.conf':
    ensure  => file,
    content => epp('pure_barman/barman.epp'),
    owner   => $pure_barman::params::barman_user,
    group   => $pure_barman::params::barman_group,
    mode    => '0640',
    replace => false,
  }

  exec { 'Generate ssh keys for barman user':
    user    => $pure_barman::params::barman_user,
    command => '/usr/bin/ssh-keygen -t ed25519 -P "" -f ~/.ssh/id_ed25519',
    creates => "/home/${pure_barman::params::barman_user}/.ssh/id_ed25519",
    cwd     => "/home/${pure_barman::params::barman_user}",
  }
}

