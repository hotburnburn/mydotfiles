function pullpm --description "📥 Restore packages from saved lists"
    set -l src_dir (test -n "$argv[1]"; and echo "$argv[1]"; or echo "$HOME/dotfiles")

    if not test -f "$src_dir/pkglist.txt"
        echo "❌ 未找到包列表文件: $src_dir/pkglist.txt"
        return 1
    end

    echo "📦 安装官方包..."
    sudo pacman -S --needed - <"$src_dir/pkglist.txt"

    if test -f "$src_dir/aur_pkglist.txt"
        set -l aur_count (count (cat "$src_dir/aur_pkglist.txt"))
        if test $aur_count -gt 0
            echo "🏠 安装 AUR 包 ($aur_count 个)..."
            if type -q yay
                yay -S --needed - <"$src_dir/aur_pkglist.txt"
            else if type -q paru
                paru -S --needed - <"$src_dir/aur_pkglist.txt"
            else
                echo "⚠️ 未安装 yay/paru，跳过 AUR 包"
            end
        end
    end

    echo "✨ 恢复完成!"
end
