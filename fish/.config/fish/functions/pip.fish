function pip --wraps=pip --description 'Intercept pip and redirect to uv in uv projects'
    # 0. 拦截 Fish 自动触发的后台补全脚本，根治报错！🛡️
    if test "$argv[1]" = completion
        # 只有在系统真正有 pip 的情况下，才放行补全命令
        if command -sq pip
            command pip $argv
        end
        return 0
    end

    # 1. 探测阶段：检查当前目录是否为 uv 项目
    set -l is_uv_project 0
    if test -f pyproject.toml; or test -f uv.lock
        set is_uv_project 1
    end

    # 2. 拦截阶段：如果是 uv 项目，并且执行的是 install 操作
    if test $is_uv_project -eq 1; and test "$argv[1]" = install
        set -l packages
        set -l index_url ""
        set -l skip_next 0

        # 遍历解析包名和源地址
        for i in (seq 2 (count $argv))
            if test $skip_next -eq 1
                set skip_next 0
                continue
            end

            set -l arg $argv[$i]

            # 捕捉源配置参数
            if contains -- $arg --index-url -i --extra-index-url
                set -l next_i (math $i + 1)
                if test $next_i -le (count $argv)
                    set index_url $argv[$next_i]
                    set skip_next 1
                end
                # 忽略所有类似 --upgrade, --user 的旧 pip 参数
            else if string match -q -- "-*" $arg
                continue
                # 提取纯包名
            else
                set -a packages $arg
            end
        end

        # 3. 组装并执行 uv 命令
        set -l uv_cmd uv add $packages
        if test -n "$index_url"
            # 自动添加命名源
            set -a uv_cmd --index "auto_index=$index_url"
        end

        # 打印个好看的提示，让你知道魔法发生了 🪄
        echo -e "\e[36m🐟 Fish Wrapper: 探测到 uv 项目，已自动重写命令 🚀\e[0m"
        echo -e "\e[33m执行 -> $uv_cmd\e[0m"
        echo ""

        eval $uv_cmd
        return
    end

    # 4. 回退阶段：不是 uv 项目，或者敲的不是 install
    # 使用 `command pip` 会绕过当前 function 寻找系统真正的 pip
    # 这完美符合你的预期：如果你环境里根本没装全局 pip，这里就会自然抛出 "command not found"
    command pip $argv
end
