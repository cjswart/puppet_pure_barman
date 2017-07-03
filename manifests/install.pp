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

# == Class: pure_barman::install
#
# Installs barman from pure repo
class pure_barman::install
(
)
{

  include pure_barman::barman_user

  file { $pure_barman::params::pgpure_data_dir:
    ensure => directory,
    owner  => $pure_barman::params::barman_user,
    group  => $pure_barman::params::barman_group,
    mode   => '0750',
  }

  if $pure_barman::barman_data_dir == $pure_barman::params::barman_data_dir {
    file { $pure_barman::params::barman_data_dir:
      ensure  => 'directory',
      owner   => $pure_barman::params::barman_user,
      group   => $pure_barman::params::barman_group,
      mode    => '0700',
    }
  }
  else {
    if ! defined(File[$pure_barman::barman_data_dir]) {
      file { $pure_barman::barman_data_dir:
        ensure => 'directory',
        owner  => $pure_barman::params::barman_user,
        group  => $pure_barman::params::barman_group,
        mode   => '0700',
      }
    }
    file { $pure_barman::params::barman_data_dir:
      ensure  => 'link',
      target  => $pure_barman::barman_data_dir,
      owner  => $pure_barman::params::barman_user,
      group  => $pure_barman::params::barman_group,
      mode    => '0700',
    }
  }

  package {$pure_barman::params::barman_package:
    ensure => 'installed',
  }

  -> file { '/usr/local/bin/barman':
    ensure => link,
    target => '/usr/pgpure/barman/bin/barman',
  }

}

