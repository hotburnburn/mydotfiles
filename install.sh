#!/bin/bash

# 遇到错误即刻退出
set -e

echo "🚀 开始配置你的 Arch WSL 环境..."

# 提前获取 sudo 权限
sudo -v

# ==========================================
# 1. 更新系统并安装基础依赖
# ==========================================
# 加上了 curl，因为后面装 rustup 需要用到
echo "📦 正在更新系统并安装 git, stow, curl 和编译工具..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git stow curl base-devel

# ==========================================
# 2. 安装 AUR 助手: paru
# ==========================================
if ! command -v paru &> /dev/null; then
    echo "🛠️ 正在安装 paru..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf /tmp/paru
else
    echo "✅ paru 已安装，跳过。"
fi

# ==========================================
# 3. 批量安装官方包与 AUR 包 (git, uv, fnm 会在这里被安装)
# ==========================================
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

if [ -f "pkglist.txt" ]; then
    echo "📥 正在从 pkglist.txt 安装官方包..."
    sudo pacman -S --needed --noconfirm - < pkglist.txt
else
    echo "⚠️ 未找到 pkglist.txt，跳过官方包安装。"
fi

if [ -f "aur_pkglist.txt" ]; then
    echo "📥 正在从 aur_pkglist.txt 安装 AUR 包..."
    paru -S --needed --noconfirm - < aur_pkglist.txt
else
    echo "⚠️ 未找到 aur_pkglist.txt，跳过 AUR 包安装。"
fi

# ==========================================
# 4. 安装 Rust 工具链 (rustup)
# ==========================================
if ! command -v cargo &> /dev/null; then
    echo "🦀 正在通过 rustup 安装 Rust 工具链..."
    # -y 参数表示全部使用默认配置，实现静默免打扰安装
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    
    # 将 cargo 环境临时载入当前脚本，防止后续如果有工具依赖 cargo 报错
    source "$HOME/.cargo/env"
    echo "✅ Rust 安装完成。"
else
    echo "✅ Rust (cargo) 已安装，跳过。"
fi

# ==========================================
# 5. 切换默认 Shell 为 Fish
# ==========================================
# echo "🐟 正在配置 Fish Shell..."
# if command -v fish &> /dev/null; then
#     if [ "$SHELL" != "$(which fish)" ]; then
#         echo "   正在将默认 Shell 切换为 fish (可能需要输入密码)..."
#         chsh -s "$(which fish)"
#         echo "   ✅ 默认 Shell 切换成功！"
#     else
#         echo "   ✅ 当前默认 Shell 已经是 fish。"
#     fi
# else
#     echo "❌ 警告: 系统中未找到 fish！"
# fi

# ==========================================
# 6. 使用 Stow 创建软链接
# ==========================================
echo "🔗 正在使用 stow 创建配置文件软链接..."
# ⚠️ 注意这里加入了 cargo, uv, git 等你新加的文件夹
STOW_FOLDERS=("nvim" "fish" "git" "starship")

for folder in "${STOW_FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        stow -R -t "$HOME" "$folder"
        echo "   已链接: $folder"
    else
        echo "   ⚠️ 警告: 找不到文件夹 $folder，跳过。"
    fi
done

# ==========================================
# 7. 后台拉取 LazyVim 插件
# ==========================================
echo "📝 正在静默启动 Neovim 触发 LazyVim 插件安装..."
if command -v nvim &> /dev/null; then
    nvim --headless "+Lazy! sync" +qa
    echo "✅ LazyVim 插件同步完成。"
else
    echo "❌ Neovim 未安装，跳过插件同步。"
fi

# ==========================================
# 8. 华丽登场
# ==========================================
echo "🎉 所有配置大功告成！准备迎接你的新环境..."
sleep 1
exec fish

# perl