# 检查当前是否已经处于 Zellij 环境中 (防止无限套娃死循环)
if not set -q ZELLIJ
    exec zellij
end
