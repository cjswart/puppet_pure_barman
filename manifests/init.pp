# == Class: pure_barman
#
# Module for doing barman stuff using the PostgresPURE distribution.
class pure_barman
(
)
{

  include pure_barman::params

  class { 'pure_barman::install':
  }
  -> class { 'pure_barman::config':
  }

}

