class sshkeys {
  if $kernel == "Linux" {
    file { '/root/.ssh/authorized_keys':
    ensure  => file,
    backup  => false,
    content => template("sshkeys/authorized_keys.erb"),
  }
    service {
    sshd: ensure => running
    }
  }
}
