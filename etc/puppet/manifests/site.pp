node /^flask[0-9]{7}.*$/ {
  include sshkeys
  
  package { "python":
      ensure => "installed"
  }

  package { "python-flask":
      ensure => "installed"
  }

  package { "screen":
      ensure => "installed"
  }
  
  class { 'nginx': }
 
  nginx::resource::upstream { 'puppet_flask_app':
    members => [
      'localhost:8000'
    ],
  }
  
  nginx::resource::vhost { 'app.internal':
    proxy => 'http://puppet_flask_app',
  }

  user { 'web':
    ensure => "present",
    managehome => true,
    shell => "/bin/bash",
  }

  file { '/home/web/.ssh':
    ensure => 'directory',
    owner => 'web',
    group => 'web',
    mode => '0700'
  }

  file { '/home/web/.ssh/authorized_keys':
    ensure  => 'file',
    backup  => false,
    owner   => 'web',
    group   => 'web',
    content => template("sshkeys/authorized_keys.erb"),
  }
}
node /^sinatra[0-9]{7}.*$/ {
  include sshkeys

  package { "rubygems":
      ensure => "installed"
  }

  package { "sinatra":
      ensure => "installed",
      provider => "gem",
  }

  package { "screen":
      ensure => "installed"
  }
  
  class { 'nginx': }
 
  nginx::resource::upstream { 'puppet_sinatra_app':
    members => [
      'localhost:4567'
    ],
  }
  
  nginx::resource::vhost { 'app.internal':
    proxy => 'http://puppet_sinatra_app',
  }

  user { 'web':
    ensure => "present",
    managehome => true,
    shell => "/bin/bash",
  }

  file { '/home/web/.ssh':
    ensure => 'directory',
    owner => 'web',
    group => 'web',
    mode => '0700'
  }

  file { '/home/web/.ssh/authorized_keys':
    ensure  => 'file',
    backup  => false,
    owner   => 'web',
    group   => 'web',
    content => template("sshkeys/authorized_keys.erb"),
  }

  exec { "/etc/init.d/nginx":
    command => "/etc/init.d/nginx restart",
    path => "/usr/bin/:/bin/",
  }
}
