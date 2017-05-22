# puppet_pure_barman
Puppet module for adding barman server and making barman clients from postgres database servers.
It was developed on the PostgresPURE distribution of Splendid Data.
## To fully configure a barman server:
* add class pure_barman (like add import pure_barman in site.pp part of the barman server) and the barman server should be fully configured.
## To fully configure a barman client in a replicated cluster
* use the latest version of the pure_repmgr module
* add the fqdn of the barman server as parameter $pure_repmgr::barman_server
barman client role will configure all that is required on the barman client.
barman role will configure all (client specific  config) that is required on the barman server.
