# == Class: pure_barman::client
#
# All for barman clients
class pure_barman::client
(
  $barman_server = undef,
)
{

  include pure_barman::client_install
  include pure_barman::client_config
}

