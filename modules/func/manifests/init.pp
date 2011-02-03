# the certmaster service has a different name under RHEL vs. Debian
case $operatingsystem {
    /(Debian|Ubuntu)/: { 
        $certmaster_service = "certmasterd" 
    }
    /(RedHat|CentOS|Fedora)/: { 
        $certmaster_service = "certmaster" 
    }
    default: { 
        $certmaster_service = "certmaster" 
    }
}

