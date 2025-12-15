# @summary Manages Asterisk 22 PJSIP Transport configurations.
#
# This class creates and manages transport configuration files for Asterisk's PJSIP module.
# A transport defines the protocol, binding, and other network-related settings for SIP communication.
#
# @example Basic usage:
#   asterisk::pjsip::transport { 'transport-udp':
#     ensure      => 'present',
#     protocol    => 'udp',
#     bind        => '0.0.0.0',
#     port        => 5060,
#     local_net   => '192.168.1.0/24',
#     external_media_address => '203.0.113.1',
#     external_signaling_address => '203.0.113.1',
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the transport configuration should exist or not.
#   Default: 'present'
#
# @param protocol
#   (Enum['udp', 'tcp', 'tls', 'ws', 'wss']) Protocol for the transport.
#   Default: 'udp'
#
# @param bind
#   (String) IP address to bind the transport to.
#   Default: '0.0.0.0'
#
# @param local_net
#   (Optional[String]) Local network subnet for NAT handling.
#   Default: undef
#
# @param external_media_address
#   (Optional[String]) External IP address for media (RTP) traffic.
#   Default: undef
#
# @param external_signaling_address
#   (Optional[String]) External IP address for signaling (SIP) traffic.
#   Default: undef
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/transport-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
define asterisk::pjsip::transport (
  Enum['present', 'absent'] $ensure                     = 'present',
  Enum['udp', 'tcp']        $protocol                   = 'udp',
  String                    $bind                       = '0.0.0.0',
  Optional[String]          $local_net                  = undef,
  Optional[String]          $external_media_address     = undef,
  Optional[String]          $external_signaling_address = undef,
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/transport-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "transport-${name}-type":
    setting => 'type',
    value   => 'transport',
  }

  ini_setting { "transport-${name}-protocol":
    setting => 'protocol',
    value   => $protocol,
  }

  ini_setting { "transport-${name}-bind":
    setting => 'bind',
    value   => $bind,
  }

  if $local_net {
    ini_setting { "transport-${name}-local_net":
      setting => 'local_net',
      value   => $local_net,
    }
  }

  if $external_media_address {
    ini_setting { "transport-${name}-external_media_address":
      setting => 'external_media_address',
      value   => $external_media_address,
    }
  }

  if $external_signaling_address {
    ini_setting { "transport-${name}-external_signaling_address":
      setting => 'external_signaling_address',
      value   => $external_signaling_address,
    }
  }
}
