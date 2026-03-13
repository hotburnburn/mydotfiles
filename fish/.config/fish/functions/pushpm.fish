function pushpm --description "📦 Export Arch packages to dotfiles"
    set -l dest_dir (test -n "$argv[1]"; and echo "$argv[1]"; or echo "$HOME/dotfiles")
    set -l official_file "$dest_dir/pkglist.txt"
    set -l aur_file "$dest_dir/aur_pkglist.txt"

    # 确保目录存在
    if not test -d "$dest_dir"
        echo "📁 创建目录: $dest_dir"
        mkdir -p "$dest_dir" || begin
            echo "❌ 创建失败"
            return 1
        end
    end

    # 检查权限
    if not touch "$dest_dir/.write_test" 2>/dev/null
        echo "🚫 无写入权限: $dest_dir"
        return 1
    end
    rm -f "$dest_dir/.write_test"

    # 导出官方包
    echo "⏳ 导出官方仓库包..."
    if pacman -Qqen >"$official_file" 2>/dev/null
        set -l count (count (cat "$official_file"))
        echo "   ✅ 完成: $count 个包"
    else
        echo "   ❌ 导出失败"
        return 1
    end

    # 导出 AUR 包
    echo "⏳ 导出 AUR/本地包..."
    if pacman -Qqem >"$aur_file" 2>/dev/null
        set -l count (count (cat "$aur_file"))
        if test $count -eq 0
            echo "   ℹ️  无 AUR 包（文件已清空）"
        else
            echo "   ✅ 完成: $count 个包"
        end
    else
        echo "   ⚠️  导出失败（可能没有 AUR 包）"
    end

    # 6️⃣ 添加元数据注释（可选，不影响恢复功能）
    set -l header "# Generated: "(date "+%Y-%m-%d %H:%M:%S")" | Host: "$hostname" | User: "(whoami)
    echo -e "\n$header\n" >>"$official_file"

    echo ""
    echo "🎉 导出完成:"
    echo "   📄 $official_file"
    echo "   📄 $aur_file"
end
