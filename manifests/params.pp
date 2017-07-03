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

# == Class pure_barman::params
class pure_barman::params
{
  $barman_package        = 'barman'
  $barman_user           = 'barman'
  $barman_group          = 'barman'
  $pgpure_data_dir       = '/var/pgpure'
  $barman_data_dir       = "${pgpure_data_dir}/barman"
  $barman_conf_tree      = [ '/etc/pgpure', '/etc/pgpure/barman', '/etc/pgpure/barman/conf' , '/etc/pgpure/barman/conf/barman.d' ]
  $barman_conf           = $barman_conf_tree[-1]
  $barman_client_folders = [ 'base', 'errors', 'incoming', 'streaming', 'wals' ]
  $barman_logdir         = '/var/log/pgpure/barman'
  $barman_logfile        = "${barman_logdir}/barman.log"
  $barman_bin_dir        = '/usr/pgpure/barman/bin'
}

