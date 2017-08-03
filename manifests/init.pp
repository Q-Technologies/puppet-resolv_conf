# Class: resolv_conf
class resolv_conf(
  # Class parameters are populated from module hiera data
  String $path,
  Integer $max_name_servers,
  Integer $max_num_search,
  Integer $max_len_search,
  Integer $max_num_sortlist,

  # Class parameters are populated from module hiera data
  Collection $nameservers = ['127.0.0.1'],
  Collection $sortlist = [],
  Collection $searchlist = [],
  String $domainname = '',
  Collection $options = [],
) {

  # There are a limit to number of items that can be added to the resolv.conf.  We try to enforce them
  # in this module to drive predictable behavior


  # From the man page: Up to  MAXNS  (currently  3, see <resolv.h>) name servers may be listed
  if count( $nameservers ) > $max_name_servers {
    fail ( "${nameservers} exceeds the maximum number of nameservers (${max_name_servers}). See man resolv.conf." )
  }

  # From the man page: The domain and search keywords are mutually exclusive.  
  # If more than one instance of these keywords is present, the last instance wins.
  if $domainname != '' and ! empty( $searchlist ) {
    fail ( 'Do not specify a searchlist and a domain they are mutually exclusive. See man resolv.conf.' )
  }

  # Max of ten items in sortlist
  if count( $sortlist ) > $max_num_sortlist {
    fail ( 'Exceeded maximum number of sort list items. See man resolv.conf.' )
  }

  # The search list is currently limited to six domains with a total of 256 characters.
  if count( $searchlist ) > $max_num_search {
    fail ( 'Exceeded maximum number of search domains. See man resolv.conf.' )
  }
  $searchlist_str = join( $searchlist, ' ' )
  $searchlist_str_len = length( $searchlist_str )

  if $searchlist_str_len > $max_len_search {
    fail ( "Exceeded maximum length of the search domains field (current:${$searchlist_str_len} \
cf max:${max_len_search}). See man resolv.conf." )
  }

  # Write the actual resolv.conf
  file { $path:
    ensure  => file,
    content => epp('resolv_conf/resolv.conf.epp', {
      nameservers => $nameservers,
      sortlist    => $sortlist,
      searchlist  => $searchlist,
      domainname  => $domainname,
      options     => $options,
    }),
  }

}
