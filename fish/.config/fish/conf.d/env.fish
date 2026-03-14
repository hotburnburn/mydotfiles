# PATH相关，过滤games，添加.local/bin
set PATH (string match -v '/usr/games' $PATH)
set PATH (string match -v '/usr/local/games' $PATH)

set -x PATH ~/.local/bin/ $PATH

# XDG Base Directory
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# rustup && cargo
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
if not contains "$CARGO_HOME/bin" $PATH
    set -x PATH "$CARGO_HOME/bin" $PATH
end

# 如果 fnm 命令存在，则初始化
if type -q fnm
    fnm env --use-on-cd | source
end
