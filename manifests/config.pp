# == Class: pure_barman::config
#
# Configure a barman server to backup postgres database nodes
class pure_barman::config
(
)
{
  #Create the folder for the configuration files
  file { $pure_barman::params::barman_conf_tree:
    ensure => 'directory',
    owner  => $pure_barman::params::barman_user,
    group  => $pure_barman::params::barman_group,
    mode   => '0755',
  }

  #Create the client configuration files for all exported resources of clients linked to this barman cluster
  Barman_client_config <<| tag == $::fqdn |>>

  #reate the datafolders that should hold data for all exported resources of clients linked to this barman cluster
  Barman_client_subdirs <<| tag == $::fqdn |>>

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
  File <<| tag == "barman_client_config for ${::fqdn}" |>>

  #Create all the barman client folders as exported by barman clients (pure_barman::client_config)
  File <<| tag == "barman_datafolder for ${::fqdn}" |>>

  file { "/etc/barman/barman.epp":
     ensure  => file,
     content => epp('pure_barman/barman.epp'),
     owner   => $pure_postgres::params::postgres_user,
     group   => $pure_postgres::params::postgres_group,
     mode    => '0640',
     require => File["${pure_postgres::pg_etc_dir}/conf.d"],
     replace => false,
   }
}

