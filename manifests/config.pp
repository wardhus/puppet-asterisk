# @summary asterisk basic configuration files.
#
# This class is not intended to be used directly.
#
# @api private
#
class asterisk::config {

  assert_private()

  case $facts['os']['family'] {
    'RedHat': {
      $service_settings_path = "/etc/sysconfig/${asterisk::service_name}"
    }
    'Debian': {
      $service_settings_path = "/etc/default/${asterisk::service_name}"
    }
    default: {
      fail("Unsupported system '${facts['os']['name']}'.")
    }
  }

  augeas { 'run_asterisk':
    changes => [
      "set /files/${service_settings_path}/RUNASTERISK yes",
    ],
  }

  file { $asterisk::confdir:
    ensure => directory,
    recurse => true,
    purge   => true,
  }

  $iax_general = $asterisk::real_iax_general
  asterisk::dotd { "${asterisk::confdir}/iax":
    additional_paths => ['/etc/asterisk/iax.registry.d'],
    content          => template('asterisk/iax.conf.erb'),
  }

  $sip_general = $asterisk::real_sip_general
  asterisk::dotd { "${asterisk::confdir}/sip":
    additional_paths => ['/etc/asterisk/sip.registry.d'],
    content          => template('asterisk/sip.conf.erb'),
  }

  $voicemail_general = $asterisk::real_voicemail_general
  asterisk::dotd { "${asterisk::confdir}/voicemail":
    content => template('asterisk/voicemail.conf.erb'),
  }

  asterisk::dotd { "${asterisk::confdir}/followme":
    content => template('asterisk/followme.conf.erb'),
  }

  $http_enable = $asterisk::real_http_enable
  $http_servername = $asterisk::http_servername
  asterisk::dotd { "${asterisk::confdir}/http":
    content => template('asterisk/http.conf.erb'),
  }

  $ext_context = {
    general => $asterisk::real_extensions_general,
    globals => $asterisk::extensions_globals,
  }
  asterisk::dotd { "${asterisk::confdir}/extensions":
    content => epp('asterisk/extensions.conf.epp', $ext_context),
  }

  $agents_multiplelogin = $asterisk::real_agents_multiplelogin
  asterisk::dotd { "${asterisk::confdir}/agents":
    content => template('asterisk/agents.conf.erb'),
  }

  $features_general = $asterisk::real_features_general
  asterisk::dotd { "${asterisk::confdir}/features":
    content          => template('asterisk/features.conf.erb'),
  }

  $queues_general = $asterisk::real_queues_general
  asterisk::dotd { "${asterisk::confdir}/queues":
    content => template('asterisk/queues.conf.erb'),
  }

  $manager_enable = $asterisk::real_manager_enable
  $manager_webenable = $asterisk::real_manager_webenable
  $manager_port = $asterisk::manager_port
  $manager_bindaddr = $asterisk::manager_bindaddr
  asterisk::dotd { "${asterisk::confdir}/manager":
    content => template('asterisk/manager.conf.erb'),
  }

  $modules_autoload = $asterisk::real_modules_autoload
  file { "${asterisk::confdir}/modules.conf" :
    ensure  => present,
    content => template('asterisk/modules.conf.erb'),
    owner   => 'root',
    group   => 'asterisk',
    mode    => '0640',
  }

}
