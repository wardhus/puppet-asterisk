# @summary Manages Asterisk PJSIP Authentication configurations.
#
# This class creates and manages authentication configuration files for Asterisk's PJSIP module.
#
# @example Basic usage:
#   asterisk::pjsip::auth { '1001':
#     ensure      => 'present',
#     username    => '1001',
#     password    => 'secret',
#     auth_type   => 'userpass',
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the auth configuration should exist or not.
#   Default: 'present'
#
# @param username
#   (String) Username for authentication.
#   Default: $name
#
# @param password
#   (String) Password for authentication.
#   Default: undef
#
# @param auth_type
#   (Enum['userpass', 'md5']) Authentication type.
#   Default: 'userpass'
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/auth-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
define asterisk::pjsip::auth (
  Enum['present', 'absent'] $ensure    = 'present',
  String                    $username  = $name,
  String                    $password  = undef,
  Enum['userpass', 'md5']   $auth_type = 'userpass',
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/auth-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "auth-${name}-type":
    setting => 'type',
    value   => 'auth',
  }

  ini_setting { "auth-${name}-username":
    setting => 'username',
    value   => $username,
  }

  ini_setting { "auth-${name}-password":
    setting => 'password',
    value   => $password,
  }

  ini_setting { "auth-${name}-auth_type":
    setting => 'auth_type',
    value   => $auth_type,
  }
}
