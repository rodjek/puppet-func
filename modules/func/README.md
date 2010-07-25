puppet-func
===========

This is a module for Puppet that will turn your existing Puppetmaster box 
into a Func overlord and your Puppet hosts into Func minions (making use of 
the existing Puppet SSL certificates for authentication, rather than 
generating new ones for Func).

## Requirements #############################################################

 * Puppet
 * Augeas (w/ Ruby bindings)
 * Func & Certmaster packages

## Install ##################################################################

    # cd /path/to/your/puppet/modules
    # git clone git://github.com/rodjek/puppet-func.git func
    # /etc/init.d/puppetmaster restart

## Usage ####################################################################

### func::overlord (puppetmaster) ###########################################

Add the following to your Puppetmaster's manifest

    func::overlord { $fqdn:
        listen_address       => "<IP address to bind to>",
    }

#### Parameters #############################################################

 * __listen_address:__ The IP that certmaster will listen on
 * __certmaster_version:__ The package version that you want to install 
  (defaults to "installed")
 * __puppetmaster_ssl_dir:__ The path that puppetmasterd stores it's SSL
  certificates in (defaults to "/var/lib/puppet/ssl")

### func::minion (puppet) ###################################################

Add the following to the manifests of all the hosts you want Func to have
access to (this may also include the Puppetmaster)

    func::minion { $fqdn: }

#### Parameters #############################################################

 * __master:__ The FQDN or IP of the Func overlord (defaults to 
  "puppet.${domain}")
 * __func_version:__ The package version that you want to install (defaults
  to "installed")
 * __puppet_ssl_dir:__ The path that puppetd stores it's SSL certificates in
  (defaults to "/var/lib/puppet/ssl")
