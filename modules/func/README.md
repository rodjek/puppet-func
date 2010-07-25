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

Add the following to your Puppetmaster's manifest

    func::overlord { $fqdn:
        listen_address => "<IP address to bind to>",
    }

Add the following to the manifests of all the hosts you want Func to have
access to (this may also include the Puppetmaster)

    func::minion { $fqdn:
        master => "<FQDN or IP of your Puppetmaster>",
    }
