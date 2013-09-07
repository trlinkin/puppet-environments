# Required Modules:
#   - puppetlabs/inifile
#   - puppetlabs/pe_gem

$r10k_environments_dir    = '/etc/puppetlabs/puppet/environments'
$r10k_environments_remote = 'https://github.com/puppetlabs-seteam/puppet-environments'

$r10k_config_content = "---
# The location to use for storing cached Git repos
:cachedir: '/var/cache/r10k'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in ${r10k_environments_dir}
  :seteam:
    remote:  '${r10k_environments_remote}'
    basedir: '${r10k_environments_dir}'

# This directory will be purged of any directory that doesn't map to a
# git branch
:purgedirs:
  - '${r10k_environments_dir}'
"

package { 'git':
  ensure => present,
}

package { 'r10k':
  ensure   => present,
  provider => pe_gem,
}

file { '/etc/r10k.yaml':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => $r10k_config_content,
}

exec { 'instantiate_environment':
  command => '/opt/puppet/bin/r10k deploy environment -p',
  creates => $r10k_environments_dir,
  require => [
    Package['r10k'],
    Package['git'],
    File['/etc/r10k.yaml'],
  ],
}

ini_setting { 'puppet_modulepath':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'main',
  setting => 'modulepath',
  value   => "${r10k_environments_dir}:/opt/puppet/share/puppet/modules",
}
