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
#   (Optional[Enum['present', 'absent']]) Whether the AOR configuration should exist or not.
#   Default: 'present'
#
# @param max_contacts
#   (Optional[Integer]) Maximum number of contacts that can bind to this AOR.
#   Default: undef
#
# @param remove_existing
#   (Optional[Enum['yes', 'no']]) Whether to remove existing contacts that are not currently registered.
#   Default: undef
#
# @param qualify
#   (Optional[Enum['yes', 'no']]) Whether to periodically qualify the contact(s) associated with this AOR.
#   Default: undef
#
# @param qualify_frequency
#   (Optional[Integer]) Interval (in seconds) at which to qualify the contact(s).
#   Default: undef
#
# @param contact
#   (Optional[String]]) Explicit contact address for this AOR.
#   Default: undef
#
# @param default_expiration
#   (Optional[Integer]) Default expiration time (in seconds) for contacts binding to this AOR.
#   Default: undef
#
# @param minimum_expiration
#   (Optional[Integer]) Minimum expiration time (in seconds) for contacts binding to this AOR.
#   Default: undef
#
# @note
#   This class creates a configuration file at `/etc/asterisk/pjsip.d/aor-${name}.conf`.
#   The Asterisk service will be notified and reloaded if the configuration changes.
#
# @see https://wiki.asterisk.org/wiki/display/AST/PJSIP+Configuration+Files
#      for more information on PJSIP configuration in Asterisk.
define asterisk::pjsip::aor (
  Enum['present', 'absent']   $ensure            = 'present',
  Optional[Integer]           $max_contacts       = undef,
  Optional[Enum['yes', 'no']] $remove_existing    = undef,
  Optional[Enum['yes', 'no']] $qualify            = undef,
  Optional[Integer]           $qualify_frequency  = undef,
  Optional[String]            $contact            = undef,
  Optional[Integer]           $default_expiration = undef,
  Optional[Integer]           $minimum_expiration = undef,
) {
  Ini_setting {
    ensure  => absent,
    path    => "/etc/asterisk/pjsip.d/aor-${name}.conf",
    section => $name,
    require => File['/etc/asterisk/pjsip.d/'],
    notify  => Service['asterisk'],
  }

  ini_setting { "aor-${name}-type":
    ensure  => $ensure,
    setting => 'type',
    value   => 'aor',
  }

  $max_contacts_ensure = $max_contacts ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-max_contacts":
    ensure  => $max_contacts_ensure,
    setting => 'max_contacts',
    value   => $max_contacts,
  }

  $remove_existing_ensure = $remove_existing ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-remove_existing":
    ensure  => $remove_existing_ensure,
    setting => 'remove_existing',
    value   => $remove_existing,
  }

  $qualify_ensure = $qualify ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-qualify":
    ensure  => $qualify_ensure,
    setting => 'qualify',
    value   => $qualify,
  }

  $qualify_frequency_ensure = $qualify_frequency ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-qualify_frequency":
    ensure  => $qualify_frequency_ensure,
    setting => 'qualify_frequency',
    value   => $qualify_frequency,
  }

  $contact_ensure = $contact ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-contact":
    ensure  => $contact_ensure,
    setting => 'contact',
    value   => $contact,
  }

  $default_expiration_ensure = $default_expiration ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-default_expiration":
    ensure  => $default_expiration_ensure,
    setting => 'default_expiration',
    value   => $default_expiration,
  }

  $minimum_expiration_ensure = $minimum_expiration ? {
    undef   => 'absent',
    default => 'present',
  }
  ini_setting { "aor-${name}-minimum_expiration":
    ensure  => $minimum_expiration_ensure,
    setting => 'minimum_expiration',
    value   => $minimum_expiration,
  }
}

