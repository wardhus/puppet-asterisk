# @summary Manages Asterisk PJSIP Identify configurations.
#
# This class creates and manages identify configuration files for Asterisk's PJSIP module.
#
# @example Basic usage:
#   asterisk::pjsip::identify { '1001':
#     ensure    => 'present',
#     endpoint  => '1001',
#     match     => '192.168.1.100',
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the identify configuration should exist or not.
#   Default: 'present'
#
# @param endpoint
#   (String) Endpoint to associate with this identify.
#   Default: $name
#
# @param match
#   (String) IP address or hostname to match for identification.
#   Default: undef
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/identify-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
define asterisk::pjsip::identify (
  Enum['present', 'absent'] $ensure  = 'present',
  String                    $endpoint = $name,
  String                    $match    = undef,
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/identify-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "identify-${name}-type":
    setting => 'type',
    value   => 'identify',
  }

  ini_setting { "identify-${name}-endpoint":
    setting => 'endpoint',
    value   => $endpoint,
  }

  ini_setting { "identify-${name}-match":
    setting => 'match',
    value   => $match,
  }
}
