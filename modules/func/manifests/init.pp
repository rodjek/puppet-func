# Exec needs a default search path or it will throw an unhelpful error
Exec {
    path    => ["/sbin", "/usr/sbin", "/bin", "/usr/bin"],
}
