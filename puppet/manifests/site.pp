include mikonwordpress

class{  'mysql::server':
         root_password => 'kddi77PF32d',}

mysql::db { 'wordpress':
  user     => 'mikkoknutas',
  password => 'lfhog4kspsF',
  host     => 'localhost',
  grant    => ['ALL'],
}

