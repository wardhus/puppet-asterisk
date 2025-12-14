# @summary Manages Asterisk PJSIP Endpoint configurations.
#
# This class creates and manages endpoint configuration files for Asterisk's PJSIP module.
#
# @example Basic usage:
#   asterisk::pjsip::endpoint { '1001':
#     ensure          => 'present',
#     transport       => 'transport-udp',
#     aors           => '1001',
#     auth            => 'auth-1001',
#     context         => 'default',
#     disallow        => 'all',
#     allow           => 'ulaw',
#     direct_media    => 'yes',
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the endpoint configuration should exist or not.
#   Default: 'present'
#
# @param transport
#   (String) Transport to use for this endpoint.
#   Default: undef
#
# @param aors
#   (String) AOR(s) to associate with this endpoint.
#   Default: $name
#
# @param auth
#   (String) Authentication object for this endpoint.
#   Default: undef
#
# @param context
#   (String) Dialplan context for this endpoint.
#   Default: 'default'
#
# @param disallow
#   (String) Codecs to disallow.
#   Default: 'all'
#
# @param allow
#   (String) Codecs to allow.
#   Default: undef
#
# @param direct_media
#   (Enum['yes', 'no']) Whether to allow direct media (reinvite).
#   Default: 'yes'
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/endpoint-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
# @see https://docs.asterisk.org/Latest_API/API_Documentation/Dialplan_Functions/PJSIP_ENDPOINT/
#      for more information on PJSIP configuration in Asterisk.
define asterisk::pjsip::endpoint (
  Enum['present', 'absent'] $ensure    = 'present',
  String                    $transport = undef,
  String                    $aors      = $name,
  String                    $auth      = undef,
  String                    $context   = 'default',
  String                    $disallow  = 'all',
  String                    $allow     = undef,
  Enum['yes', 'no']         $direct_media = 'yes',
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/endpoint-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "endpoint-${name}-type":
    setting => 'type',
    value   => 'endpoint',
  }

  if $transport {
    ini_setting { "endpoint-${name}-transport":
      setting => 'transport',
      value   => $transport,
    }
  }

  ini_setting { "endpoint-${name}-aors":
    setting => 'aors',
    value   => $aors,
  }

  if $auth {
    ini_setting { "endpoint-${name}-auth":
      setting => 'auth',
      value   => $auth,
    }
  }

  ini_setting { "endpoint-${name}-context":
    setting => 'context',
    value   => $context,
  }

  ini_setting { "endpoint-${name}-disallow":
    setting => 'disallow',
    value   => $disallow,
  }

  if $allow {
    ini_setting { "endpoint-${name}-allow":
      setting => 'allow',
      value   => $allow,
    }
  }

  ini_setting { "endpoint-${name}-direct_media":
    setting => 'direct_media',
    value   => $direct_media,
  }
}
