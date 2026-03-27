# PATH相关，过滤games，添加.local/bin
set PATH (string match -v '/usr/games' $PATH)
set PATH (string match -v '/usr/local/games' $PATH)

function myaddpath
    if not contains $argv[1] $PATH
        set -x PATH $argv[1] $PATH
    end
end

myaddpath "$HOME/.local/bin"

# XDG Base Directory
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# rustup && cargo
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
myaddpath "$CARGO_HOME/bin"

# bun
set -gx BUN_INSTALL "$HOME/.local/share/bun"
myaddpath "$BUN_INSTALL/bin"

# fnm && npm
if not set -q FNM_MULTISHELL_PATH
    if type -q fnm
        fnm env --use-on-cd | source
    end
end
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# other path
set -gx CUDA_CACHE_PATH "$XDG_CACHE_HOME/nv"
set -gx IPYTHONDIR "$XDG_DATA_HOME/ipython"
