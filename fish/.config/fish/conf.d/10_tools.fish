abbr -a ins "yay -S --needed"
abbr -a pmclean "sudo pacman -Rns \$(pacman -Qtdq)"

# 强制 GUI 程序走 X11/XWayland 通道，解决 Open3D/Wayland 冲突
set -gx WAYLAND_DISPLAY ""

starship init fish | source

zoxide init fish | source
zoxide init fish --cmd cd | source
alias z="zi"
abbr -a gb "cd -"
abbr -a cd. "cd .."

set -gx EDITOR nvim
abbr -a v nvim

abbr -a rgi "rg -i"
abbr -a rg. "rg -."
abbr -a rgi. "rg -i -."

abbr -a ga "git add ."
abbr -a gcm --set-cursor 'git commit -m "%"'
abbr -a gst "git status"
abbr -a gd "git diff"
abbr -a glg 'git log --stat'
# 默认的 glog，限制只看最近 10 条提交 📉
abbr -a glog "git log -n 10 --graph --pretty=format:'%Cred%h%Creset -%s %Cgreen(%cr) %C(bold blue)<%an>%Creset %C(yellow)%d%Creset' --abbrev-commit"
# 新增的 gloga (glog all)，查看完整的提交树 🌳
abbr -a gloga "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# 绑定 abbr
abbr -a eb --function _exercism_dynamic_submit

# ==========================================
# 🚀 Zoxide + FZF 终极目录瞬移魔法
# ==========================================
# 劫持 zoxide 的交互模式 (zi)，强行注入 eza 目录树预览
set -gx _ZO_FZF_OPTS "--preview 'eza --tree --color=always (string split \t {})[-1] | head -200' "\
"--preview-window=right:50%:border-left "\
"--height 60% "\
"--layout=reverse "\
"--border=rounded "\
"--prompt='🚀 goto > '"

# 让 ls 变成带图标和颜色的 eza
alias ls="eza --icons"
alias ll="eza -l -g --icons --git" # 长格式，带 Git 状态
alias la="eza -la -g --icons --git" # 显示隐藏文件
alias tree="eza --tree --icons" # 代替传统的 tree 命令
abbr -a ta "tree -a"

# 让 cat 变成带高亮的 bat
alias cat="bat"

# 让 top 变成更直观的 bottom
alias top="btm"
