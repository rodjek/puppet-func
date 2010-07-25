define func::minion($master, $func_version=installed, $puppet_ssl_dir="/var/lib/puppet/ssl") {
    package { "func":
        ensure => $func_version,
    }

    service { "funcd":
        ensure  => running,
        enable  => true,
        require => Package["func"],
    }

    file { 
        "${puppet_ssl_dir}/func":
            ensure => directory,
            owner  => "puppet",
            group  => "puppet",
            mode   => 0555;
        "${puppet_ssl_dir}/func/ca.cert":
            ensure => "${puppet_ssl_dir}/certs/ca.pem";
        "${puppet_ssl_dir}/func/${fqdn}.cert":
            ensure => "${puppet_ssl_dir}/certs/${fqdn}.pem";
        "${puppet_ssl_dir}/func/${fqdn}.csr":
            ensure => "${puppet_ssl_dir}/csr_${fqdn}.pem";
        "${puppet_ssl_dir}/func/${fqdn}.pem":
            ensure => "${puppet_ssl_dir}/private_keys/${fqdn}.pem";
        "/usr/share/augeas/lenses/funcminion.aug":
            ensure  => present,
            source  => "puppet:///func/usr/share/augeas/lenses/funcminion.aug",
            owner   => "root",
            group   => "root",
            mode    => 0444,
            require => Package["func"];
    }

    Augeas {
        context => "/files/etc/certmaster/minion.conf/main",
        notify  => Service["funcd"],
        require => File["/usr/share/augeas/lenses/funcminion.aug"],
    }

    augeas {
        "Set cert_dir to ${puppet_ssl_dir}/func":
            changes => "set cert_dir ${puppet_ssl_dir}/func",
            require => [File["${puppet_ssl_dir}/func/ca.cert"],
                        File["${puppet_ssl_dir}/func/${fqdn}.cert"],
                        File["${puppet_ssl_dir}/func/${fqdn}.csr"],
                        File["${puppet_ssl_dir}/func/${fqdn}.pem"],
                        File["/usr/share/augeas/lenses/funcminion.aug"]];
        "Set certmaster to ${master}":
            changes => "set certmaster ${master}";
    }
}
