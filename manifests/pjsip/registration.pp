# @summary Manages Asterisk PJSIP Registration configurations.
#
# This class creates and manages registration configuration files for Asterisk's PJSIP module.
#
# @example Basic usage:
#   asterisk::pjsip::registration { '1001':
#     ensure         => 'present',
#     transport      => 'transport-udp',
#     outbound_auth  => 'auth-1001',
#     server_uri     => 'sip:provider.com',
#     client_uri     => 'sip:1001@provider.com',
#     retry_interval => 60,
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the registration configuration should exist or not.
#   Default: 'present'
#
# @param transport
#   (String) Transport to use for registration.
#   Default: undef
#
# @param outbound_auth
#   (String) Authentication object for outbound registration.
#   Default: undef
#
# @param server_uri
#   (String) URI of the server to register to.
#   Default: undef
#
# @param client_uri
#   (String) URI of the client registering.
#   Default: undef
#
# @param retry_interval
#   (Integer) Interval (in seconds) to retry registration.
#   Default: 60
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/registration-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
define asterisk::pjsip::registration (
  Enum['present', 'absent'] $ensure          = 'present',
  Optional[String]          $transport       = undef,
  String                    $outbound_auth   = undef,
  String                    $server_uri      = undef,
  String                    $client_uri      = undef,
  Integer                   $retry_interval  = 60,
  String                    $contact_user    = undef,
  String                    $auth_rejection_permanent = undef,
  Integer                   $forbidden_retry_interval = undef,
  Integer                   $max_retries              = undef,
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/registration-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "registration-${name}-type":
    setting => 'type',
    value   => 'registration',
  }

  if $transport {
    ini_setting { "registration-${name}-transport":
      setting => 'transport',
      value   => $transport,
    }
  }

  if $outbound_auth {
    ini_setting { "registration-${name}-outbound_auth":
      setting => 'outbound_auth',
      value   => $outbound_auth,
    }
  }

  if $server_uri {
    ini_setting { "registration-${name}-server_uri":
      setting => 'server_uri',
      value   => $server_uri,
    }
  }

  if $client_uri {
    ini_setting { "registration-${name}-client_uri":
      setting => 'client_uri',
      value   => $client_uri,
    }
  }

  ini_setting { "registration-${name}-retry_interval":
    setting => 'retry_interval',
    value   => $retry_interval,
  }


  ini_setting { "registration-${name}-contact_user":
    setting => 'contact_user',
    value   => $contact_user,
  }
  ini_setting { "registration-${name}-auth_rejection_permanent":
    setting => 'auth_rejection_permanent',
    value   => $auth_rejection_permanent,
  }
  ini_setting { "registration-${name}-forbidden_retry_interval":
    setting => 'forbidden_retry_interval',
    value   => $forbidden_retry_interval,
  }
  ini_setting { "registration-${name}-max_retries":
    setting => 'max_retries',
    value   => $max_retries,
  }
}
