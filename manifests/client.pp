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

# == Class: pure_barman::client
#
# All for barman clients
class pure_barman::client
(
  $barman_server = undef,
)
{
  include pure_barman::params

  include pure_barman::client_install
  include pure_barman::client_config
}

