define func::overlord($listen_address, $certmaster_version=installed,
        $puppetmaster_ssl_dir="/var/lib/puppet/ssl") {

    package { "certmaster":
        ensure => $certmaster_version;
    }

    service { "certmaster":
        ensure  => "running",
        enable  => "true",
        require => Package["certmaster"],
    }

    exec { "Remove passphrase from Puppetmaster CA key":
        cwd     => "${puppetmaster_ssl_dir}/ca",
        command => "openssl rsa -in ca_key.pem -out ca_key_nopassphrase.pem -passin file:private/ca.pass",
        creates => "${puppetmaster_ssl_dir}/ca/ca_key_nopassphrase.pem",
    }

    file {
        "${puppetmaster_ssl_dir}/ca/certmaster.key":
            ensure  => "${puppetmaster_ssl_dir}/ca/ca_key_nopassphrase.pem",
            require => Exec["Remove passphrase from Puppetmaster CA key"];
        "${puppetmaster_ssl_dir}/ca/certmaster.crt":
            ensure => "${puppetmaster_ssl_dir}/ca/ca_crt.pem";
        "/usr/share/augeas/lenses/funccertmaster.aug":
            ensure  => present,
            source  => "puppet:///func/usr/share/augeas/lenses/funccertmaster.aug",
            owner   => "root",
            group   => "root",
            mode    => 0444,
            require => Package["certmaster"];
    }
    
    Augeas {
        notify  => Service["certmaster"],
        require => File["/usr/share/augeas/lenses/funccertmaster.aug"],
        context => "/files/etc/certmaster/certmaster.conf/main",
    }

    augeas {
        "Set cadir to ${puppetmaster_ssl_dir}/ca":
            changes => "set cadir ${puppetmaster_ssl_dir}/ca",
            require => [File["${puppetmaster_ssl_dir}/ca/certmaster.key"],
                        File["${puppetmaster_ssl_dir}/ca/certmaster.crt"]];
        "Set certroot to ${puppetmaster_ssl_dir}/ca/signed":
            changes => "set certroot ${puppetmaster_ssl_dir}/ca/signed";
        "Set cert_extension to pem":
            changes => "set cert_extension pem";
        "Set listen_addr to ${listen_address}":
            changes => "set listen_addr ${listen_address}";
    }
}
