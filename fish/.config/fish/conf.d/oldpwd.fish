# 1. 记录终端刚启动时的初始目录
set -g __my_previous_pwd $PWD

# 2. 挂载监听器：只要 PWD（当前路径）发生变化，立刻更新并导出 OLDPWD
function __track_oldpwd --on-variable PWD
    if test -n "$__my_previous_pwd"
        # -gx 意味着设为全局(g)并导出为环境变量(x)，这样 Starship 就能读到了
        set -gx OLDPWD $__my_previous_pwd
    end
    set -g __my_previous_pwd $PWD
end
