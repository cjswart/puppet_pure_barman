# == Class: pure_barman::client_install
#
# Configure a postgres database server to be backed up by a barman server
class pure_barman::client_install
(
)
{

  if ! defined(Package[ 'rsync' ]) {
    package { 'rsync':
      ensure => 'installed',
    }
  }
}

