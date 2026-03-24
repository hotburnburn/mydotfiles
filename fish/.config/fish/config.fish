set -gx EDITOR nvim

if status is-interactive
    if not set -q ZELLIJ
        # 排除 VS Code 集成终端
        and test "$TERM_PROGRAM" != vscode
        # 排除 WezTerm（这样你可以在 WezTerm 里测试它的原生功能）
        and test "$TERM_PROGRAM" != WezTerm
        # 如果是 Windows Terminal 或其他终端，继续拉起 zellij
        exec zellij
    end
end
