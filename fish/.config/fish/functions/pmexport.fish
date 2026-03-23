function pmexport --description "Export explicit installed packages to dotfiles"
    # 定义目标文件路径
    set dest ~/dotfiles/pkglist.txt
    mkdir -p (dirname $dest)

    echo "[1/3] 📦 导出官方包..."
    echo "# 官方包" >$dest
    pacman -Qqen >>$dest

    echo "[2/3] 🏪 导出AUR包..."
    echo "" >>$dest
    echo "# aur包" >>$dest
    pacman -Qqem >>$dest

    echo "[3/3] 🗃️ 添加元数据..."
    set official_count (pacman -Qqen | wc -l)
    set aur_count (pacman -Qqem | wc -l)
    set total_count (math $official_count + $aur_count)

    echo "" >>$dest
    echo "# === 元数据与统计信息 ===" >>$dest
    echo "# 更新时间: "(date "+%Y-%m-%d %H:%M:%S") >>$dest
    echo "# 设备名称: $hostname" >>$dest
    echo "# 官方包数: $official_count" >>$dest
    echo "# AUR包数 : $aur_count" >>$dest
    echo "# 总包数量: $total_count" >>$dest

    echo "✅ 已导出至：$dest"
end
