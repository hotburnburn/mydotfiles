function pmimport --description "Import, sync and prune packages from dotfiles"
    set src ~/dotfiles/pkglist.txt

    # 1. 预处理
    if not test -f $src
        echo "❌ 错误: 找不到包列表文件 $src"
        return 1
    end

    echo "🔍 正在读取并过滤包列表..."
    set pkglist (rg -v '^\s*(#|$)' $src)

    if test (count $pkglist) -eq 0
        echo "⚠️ 列表中没有找到需要安装的包。"
        return 0
    end

    sudo pacman -Syu

    # 2. 安装包
    echo "[1/2] 🚀 准备同步 "(count $pkglist)" 个包..."
    yay -S --needed $pkglist

    # 3. 处理多的包
    echo "[2/2] 🔍 正在检查系统中多余的显式安装包..."

    # 获取当前系统中所有显式安装的包 (原生 + AUR)
    set installed_pkgs (pacman -Qqe)

    # 利用 comm 命令比对差异 (找出在 installed 中但不在 pkglist 中的包)
    # 解释：
    # comm -23 表示只输出“仅在第一个文件(已安装)中存在”的行
    # psub 是 fish 的进程替换语法，将命令输出虚拟成一个文件描述符给 comm 读取
    set pkgs_to_remove (comm -23 (printf "%s\n" $installed_pkgs | sort | psub) (printf "%s\n" $pkglist | sort | psub))

    # 3. 判断并提示用户
    if test (count $pkgs_to_remove) -gt 0
        echo "⚠️ 发现 "(count $pkgs_to_remove)" 个系统中显式安装的包，但不在你的 $src 列表中："

        # 打印出多余的包，方便用户查看
        set_color yellow
        printf "   📦 %s\n" $pkgs_to_remove
        set_color normal
        echo ""

        # 提示用户输入 (默认 N)
        read -l -P "❓ 是否要卸载这些多余的包及其不再需要的依赖？[y/N]: " confirm

        switch $confirm
            case Y y yes Yes
                echo "🗑️ 正在清理冗余包..."
                # 使用 -Rns: -R(卸载) -n(删除配置文件) -s(删除不再被依赖的包)
                yay -Rns $pkgs_to_remove
                echo "✅ 清理完成！"
            case '*'
                echo "⏸️ 操作取消：已跳过卸载。"
        end
    else
        echo "✨ 太棒了！系统当前的显式包状态与你的列表完全一致，没有任何多余的包。"
    end

    echo "🎉 pmimport 执行完毕！"
end
