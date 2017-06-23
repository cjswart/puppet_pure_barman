# Copyright (C) 2017 Collaboration of KPN and Splendid Data 
#
# This file is part of the puppet_pure_barman module.
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

# == Class: pure_barman
#
# Module for doing barman stuff using the PostgresPURE distribution.
class pure_barman
(
) inherits pure_barman::params
{

  class { 'pure_barman::install':
  }
  -> class { 'pure_barman::config':
  }

}

