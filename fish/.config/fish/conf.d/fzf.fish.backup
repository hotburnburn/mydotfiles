# ==========================================
# 🔍 FZF 终极形态：文件与目录混合动态预览
# ==========================================

# 1. 启用 fzf 的 Fish 原生快捷键绑定
fzf --fish | source

# 2. 让 fd 同时搜索文件和目录 (去掉了 --type f)
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

# 3. 核心魔法：动态判断预览器
# 这里的代码是在底层的 sh 中执行的
# [ -d {} ] 判断选中的路径是不是目录 (directory)
# 如果是目录，就用 eza 画树状图；否则，就用 bat 高亮文件内容
# ==========================================
# 🔍 FZF 终极形态 (防弹修复版)
# ==========================================
set -gx FZF_CTRL_T_OPTS "--preview 'if test -d {}; eza --tree --color=always {} | head -200; else; bat --color=always --style=numbers --line-range=:500 {}; end' "\
"--preview-window=right:60%:border-left "\
"--bind 'alt-e:execute(nvim {})' "\
"--height 60% "\
"--layout=reverse "\
"--border=rounded "\
"--prompt='🔍 搜索 > '"

set -gx FZF_DEFAULT_OPTS "--height 60% --layout=reverse --border --bind 'alt-j:down,alt-k:up'"

# ==========================================
# ⌨️ 自定义快捷键映射 (现代 Fish 极简版)
# ==========================================
# 直接写 bind，不需要 function 包裹！

# 1. 绑定 Alt+J 为文件搜索 (替代原 Ctrl+T)
bind \ej fzf-file-widget

# 2. 绑定 Alt+K 为历史命令搜索 (替代原 Ctrl+R)
bind \ek fzf-history-widget

# (可选) 解除原本的 Ctrl 绑定
bind --erase \ct
bind --erase \cr
