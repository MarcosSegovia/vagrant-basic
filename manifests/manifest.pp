apache::vhost {'localhost':
      port       => 8080,
      docroot    => '/var/www',
      priority   => 25,
      servername => 'puppet',
    }