# @summary Manages Asterisk PJSIP Address of Record (AOR) configurations.
#
# This class creates and manages AOR configuration files for Asterisk's PJSIP module.
# An AOR (Address of Record) is used to define the location of a SIP endpoint.
#
# @example Basic usage:
#   asterisk::pjsip::aor { '1001':
#     ensure            => 'present',
#     max_contacts      => 2,
#     remove_existing   => 'yes',
#     qualify           => 'yes',
#     qualify_frequency => 30,
#     contact           => 'sip:1001@192.168.1.100:5060',
#   }
#
# @param ensure
#   (Enum['present', 'absent']) Whether the AOR configuration should exist or not.
#   Default: 'present'
#
# @param max_contacts
#   (Integer) Maximum number of contacts that can bind to this AOR.
#   Default: 1
#
# @param remove_existing
#   (Enum['yes', 'no']) Whether to remove existing contacts that are not currently registered.
#   Default: 'yes'
#
# @param qualify
#   (Enum['yes', 'no']) Whether to periodically qualify the contact(s) associated with this AOR.
#   Default: 'no'
#
# @param qualify_frequency
#   (Integer) Interval (in seconds) at which to qualify the contact(s).
#   Default: 60
#
# @param contact
#   (Optional[String]) Explicit contact address for this AOR.
#   Default: undef
#
# @param default_expiration
#   (Integer) Default expiration time (in seconds) for contacts binding to this AOR.
#   Default: 3600
#
# @param minimum_expiration
#   (Integer) Minimum expiration time (in seconds) for contacts binding to this AOR.
#   Default: 60
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/aor-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
#
# @see https://wiki.asterisk.org/wiki/display/AST/PJSIP+Configuration+Files
#      for more information on PJSIP configuration in Asterisk.
define asterisk::pjsip::aor (
  Enum['present', 'absent'] $ensure            = 'present',
  Integer                   $max_contacts       = 1,
  Enum['yes', 'no']         $remove_existing    = 'yes',
  Enum['yes', 'no']         $qualify            = 'no',
  Integer                   $qualify_frequency  = 60,
  Optional[String]          $contact            = undef,
  Integer                   $default_expiration = 3600,
  Integer                   $minimum_expiration = 60,
) {
  Ini_setting {
    ensure  => $ensure,
    path    => "/etc/asterisk/pjsip.d/aor-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "aor-${name}-type":
    setting => 'type',
    value   => 'aor',
  }

  ini_setting { "aor-${name}-max_contacts":
    setting => 'max_contacts',
    value   => $max_contacts,
  }

  ini_setting { "aor-${name}-remove_existing":
    setting => 'remove_existing',
    value   => $remove_existing,
  }

  ini_setting { "aor-${name}-qualify":
    setting => 'qualify',
    value   => $qualify,
  }

  ini_setting { "aor-${name}-qualify_frequency":
    setting => 'qualify_frequency',
    value   => $qualify_frequency,
  }

  if $contact {
    ini_setting { "aor-${name}-contact":
      setting => 'contact',
      value   => $contact,
    }
  }

  ini_setting { "aor-${name}-default_expiration":
    setting => 'default_expiration',
    value   => $default_expiration,
  }

  ini_setting { "aor-${name}-minimum_expiration":
    setting => 'minimum_expiration',
    value   => $minimum_expiration,
  }
}

