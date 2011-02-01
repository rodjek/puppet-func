# Exec needs a default search path or it will throw an unhelpful error
Exec {
    path    => ["/sbin", "/usr/sbin", "/bin", "/usr/bin"],
}

# the certmaster service has a different name under RHEL vs. Debian
case $operatingsystem {
    /(Debian|Ubuntu/: { 
        $certmaster_service = "certmasterd" 
    },
    /(RedHat|CentOS|Fedora)/: { 
        $certmaster_service = "certmaster" 
    },
    default: { 
        $certmaster_service = "certmaster" 
    },
}

