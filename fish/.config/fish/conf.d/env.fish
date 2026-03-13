set -x PATH ~/.local/bin/ $PATH

# 如果 fnm 命令存在，则初始化
if type -q fnm
    fnm env --use-on-cd | source
end

source "$HOME/.cargo/env.fish"
