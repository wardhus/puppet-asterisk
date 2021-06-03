# @summary Configure an asterisk followme
#
# @example User with 2 numbers.
#   asterisk::followme { 'ward':
#     music => default,
#     context => ward,
#     number => [ 'softphone,45', 'mobile']
#   }
#
# @param music
#   The moh class that should be used for the caller while they are waiting to be connected.
# @param context
#   The context to dial the numbers from
# @param number
#   The a follow-me number to call. The format is:
#   <number to call[&2nd #[&3rd #]]> [, <timeout value in seconds> [, <order in follow-me>] ]
#
define asterisk::followme (
  String[1]         $music   = 'default',
  String[1]         $context = $name,
  Array[String[1]]  $number,
) {

  asterisk::dotd::file { "followme_${name}.conf":
    ensure   => $ensure,
    dotd_dir => 'followme.d',
    content  => template('asterisk/snippet/followme.erb'),
    filename => "${name}.conf",
  }

}
