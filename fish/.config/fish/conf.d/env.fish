set -x PATH ~/.local/bin/ $PATH

# 如果 fnm 命令存在，则初始化
if type -q fnm
    fnm env --use-on-cd | source
end

# rustup shell setup
if not contains "$HOME/.cargo/bin" $PATH
    # Prepending path in case a system-installed rustc needs to be overridden
    set -x PATH "$HOME/.cargo/bin" $PATH
end
