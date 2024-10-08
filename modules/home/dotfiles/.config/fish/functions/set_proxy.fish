function un_single_quote
    set -l s $argv[1]
    set -l s (string replace -a "'" "" $s)
    echo $s
end

function proxy_on
    # http org.gnome.system.proxy.http
    set http_host (un_single_quote (gsettings get org.gnome.system.proxy.http host))
    set http_port (un_single_quote (gsettings get org.gnome.system.proxy.http port))
    if test -n "$http_host"
        set -gx http_proxy "http://$http_host:$http_port"
        set -gx HTTP_PROXY $http_proxy
    end

    # https org.gnome.system.proxy.https
    set https_host (un_single_quote (gsettings get org.gnome.system.proxy.https host))
    set https_port (un_single_quote (gsettings get org.gnome.system.proxy.https port))
    if test -n "$https_host"
        set -gx https_proxy "http://$https_host:$https_port"
        set -gx HTTPS_PROXY $https_proxy
    end

    # ftp org.gnome.system.proxy.ftp
    set ftp_host (un_single_quote (gsettings get org.gnome.system.proxy.ftp host))
    set ftp_port (un_single_quote (gsettings get org.gnome.system.proxy.ftp port))
    if test -n "$ftp_host"
        set -gx ftp_proxy "http://$ftp_host:$ftp_port"
        set -gx FTP_PROXY $ftp_proxy
    end

    # socks org.gnome.system.proxy.socks
    set socks_host (un_single_quote (gsettings get org.gnome.system.proxy.socks host))
    set socks_port (un_single_quote (gsettings get org.gnome.system.proxy.socks port))
    if test -n "$socks_host"
        set -gx all_proxy "socks://$socks_host:$socks_port"
        set -gx ALL_PROXY $all_proxy
    end

    # org.gnome.system.proxy ignore-hosts
    set ignore_hosts (gsettings get org.gnome.system.proxy ignore-hosts)
    set empty_list '[]'
    set no_proxy (string sub -s 2 -e -1 $ignore_hosts)
    set no_proxy (string replace -a ' ' '' $no_proxy)
    set no_proxy (string replace -a "'" '' $no_proxy)
    if test -n "$ignore_hosts" -a "$ignore_hosts" != "$empty_list"
        set -gx no_proxy $no_proxy
        set -gx NO_PROXY $no_proxy
    end
end

function proxy_off
    set -ge no_proxy NO_PROXY http_proxy HTTP_PROXY https_proxy HTTPS_PROXY ftp_proxy FTP_PROXY all_proxy ALL_PROXY
end

function set_proxy
    if test "$TERM" = alacritty
        # 检查代理模式
        if test (un_single_quote (gsettings get org.gnome.system.proxy mode)) = manual
            proxy_on
        end
        # 检查 http 代理认证
        if test (gsettings get org.gnome.system.proxy.http use-authentication) = true
            # HTTP 代理认证暂不支持
            set -ge http_proxy HTTP_PROXY
        end
    end
end