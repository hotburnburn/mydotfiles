function proxy
    # 这里的地址请根据你代理软件的实际端口进行修改
    set -l proxy_url "http://127.0.0.1:7897"

    switch "$argv[1]"
        case on
            set -gx http_proxy $proxy_url
            set -gx https_proxy $proxy_url
            set -gx all_proxy $proxy_url
            echo "代理已开启: $proxy_url"
        case off
            set -e http_proxy
            set -e https_proxy
            set -e all_proxy
            echo "代理已关闭"
        case status
            if set -q http_proxy
                echo "当前代理地址: $http_proxy"
            else
                echo "当前未设置代理"
            end
        case '*'
            echo "用法: proxy [on|off|status]"
    end
end
