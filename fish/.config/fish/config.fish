# 检查当前是否已经处于 Zellij 环境中 (防止无限套娃死循环)
if status is-interactive
    if not set -q ZELLIJ
        # 如果当前不是在 VS Code 的集成终端里
        and test "$TERM_PROGRAM" != vscode
        exec zellij
    end
end

set -gx EDITOR nvim
