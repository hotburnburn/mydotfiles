function ppath --description "Print PATH with line numbers (no WSL paths)"
    # 先收集有效的 Linux 路径
    set -l clean_paths
    for p in $PATH
        if not string match -q "/mnt/*" $p
            set -a clean_paths $p
        end
    end

    # 计算行号宽度（比如 10 个路径就占 2 字符宽度）
    set -l total (count $clean_paths)
    set -l width (string length $total)

    # 带对齐的行号输出
    for i in (seq $total)
        set -l num (string pad -w $width $i)
        if test -d "$clean_paths[$i]"
            echo (set_color green)"[$num] "(set_color cyan)"$clean_paths[$i]"
        else
            echo (set_color green)"[$num] "(set_color red)"$clean_paths[$i]"
        end
        set_color normal
    end
end
