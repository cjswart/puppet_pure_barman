# == Class pure_barman::params
class pure_barman::params
{
  $barman_package        = 'barman'
  $barman_user           = 'barman'
  $barman_group          = 'barman'
  $barman_data_tree      = [ '/var/pgpure', '/var/pgpure/barman' ]
  $barman_data           = $barman_data_tree[-1]
  $barman_conf_tree      = [ '/etc/pgpure', '/etc/pgpure/barman', '/etc/pgpure/barman/conf' , '/etc/pgpure/barman/conf/barman.d' ]
  $barman_conf           = $barman_conf_tree[-1]
  $barman_client_folders = [ 'base', 'errors', 'incoming', 'streaming', 'wals' ]
  $barman_logdir         = '/var/log/pgpure/barman'
  $barman_logfile        = "${barman_logdir}/barman.log"
  $barman_bin_dir        = "/usr/pgpure/barman/bin"
}

