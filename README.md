# resolv_conf
Manages resolv.conf with sensibility checks.
#### Table of Contents

1. [Description](#description)
1. [Instructions](#instructions)
1. [Limitations](#limitations)
1. [Development](#development)
1. [Issues](#issues)

## Description

This **resolv_conf** module manages the `/etc/resolv.conf` on Linux systems.  Not only does it insert the configuration, but it will also check the inputs to make sure they meet the specifications of the `resolv.conf` file.  In particular, it will follow the following rules found in the **resolv.conf** manpage:
  * Up to  MAXNS  (currently  3, see <resolv.h>) name servers may be listed
  * The domain and search keywords are mutually exclusive.
  * Max of ten pairs in sortlist
  * The search list is currently limited to six domains with a total of 256 characters.

If any of these criteria are not met, the Puppet run will fail with the reason why.  This will ensure your `resolv.conf` configuration is actioned in a predictable manner - extraneous configuration might lead to confusion when it is not acted upon by the resolver.

These criteria are consistent on Debian/Ubuntu, RedHat/Centos/OEL and Suse - let me know if any other Linux differs.

## Instructions
Call the class from your code, e.g. 
```
class { 'resolv_conf': }
```
 or 
```
include 'resolv_conf'
```

Use Hiera to drive the configuration.  E.g.:
```
resolv_conf::nameservers: 
  - 10.0.0.19
  - 10.0.0.20
  - 10.0.0.21
resolv_conf::domainname: localdomain
resolv_conf::options:
  - timeout:2
  - attempts:2
  - rotate
```
### Options
#### nameservers
An array of nameservers that the resolver should query for hostname lookups.  Max of 3 nameservers can be specified.

#### domainname
A string which is the primary domain of the host being managed.  It cannot be specified if **searchlist** is specified.

#### searchlist
An array of domains for the resolver to search through.  Max of 6, but total length cannot exceed 256 chars.  It cannot be specified if **domainname** is specified.

#### sortlist
An array of up to 10 IP-address-netmask pairs used by the resolver to sort multiple addresses returned by the **gethostbyname(3)** system call.

#### options
An array of options to give to the resolver.  Each array element is the option string (without the word option). See the **resolv.conf** manpage for a list of options and what they do.


## Limitations
The **option**s are passed through without any validation.  Is there demand for option validation?

## Development
If you would like to contribute to or comment on this module, please do so at it's Github repository.  Thanks.

## Issues
This module is using hiera data that is embedded in the module rather than using a params class.  This may not play nicely with other modules using the same technique unless you are using hiera 3.0.6 and above (PE 2015.3.2+).
