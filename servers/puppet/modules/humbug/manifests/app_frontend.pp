class humbug::app_frontend {
  class { 'humbug::base': }
  class { 'humbug::rabbit': }

  $web_packages = [ "nginx", "memcached", "python-pylibmc", "python-tornado", "python-django",
                    "python-pygments", "python-flup", "ipython", "python-psycopg2",
                    "yui-compressor", ]
  package { $web_packages: ensure => "installed" }

  file { "/etc/nginx/nginx.conf":
    require => Package[nginx],
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "/root/humbug/servers/puppet/files/nginx/nginx.conf",
  }
  file { "/etc/nginx/humbug-include/":
    require => Package[nginx],
    recurse => true,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "/root/humbug/servers/puppet/files/nginx/humbug-include/",
  }
  file { "/etc/nginx/sites-available/humbug":
    require => Package[nginx],
    ensure => file,
    owner  => "root",
    group  => "root",
    mode => 644,
    source => "/root/humbug/servers/puppet/files/nginx/sites-available/humbug",
  }

  exec {"pip6":
    command  => "pip install django-pipeline",
    onlyif   => "test ! -d /usr/local/lib/python2.6/dist-packages/django-pipeline"
  }

  # TODO: Add /usr/lib/nagios/plugins/check_send_receive_time ->
  # /home/humbug/humbug/api/humbug/bots/check_send_receive.py symlink

  # TODO: Setup the API distribution directory at /srv/www/dist/api/.
}
