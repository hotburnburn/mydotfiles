function gacp -d "Git Add, Commit, and Push 自动化流"
    # 1. 判断是否在 Git 仓库中
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "❌ 错误：当前目录不是一个 Git 仓库。"
        return 1
    end

    # 2. 判断是否为根目录
    # 如果 --show-cdup 有输出，说明在子目录中；如果没有输出，说明在根目录
    set cdup (git rev-parse --show-cdup)
    if test -n "$cdup"
        echo "⚠️ 提示：当前不在 Git 仓库的根目录。"
        echo "请 cd 回根目录（或者直接运行 'cd ./$cdup'）后再尝试。"
        return 1
    end

    # (可选优化) 检查是否有文件需要提交
    set git_status (git status --porcelain)
    if test -z "$git_status"
        echo "✨ 工作区很干净，没有需要提交的更改。"
        return 0
    end

    # 3. 交互 1：输入 commit message
    read -P "💬 请输入 commit message: " msg

    # 简单的输入校验
    if test -z "$msg"
        echo "🛑 Commit message 不能为空，已取消。"
        return 1
    end

    # 执行 Add 和 Commit
    echo "📦 正在添加并提交更改..."
    git add .
    git commit -m "$msg"

    # 4. 交互 2：选择是否 Push
    # [Y/n] 代表默认是 Yes
    read -P "🚀 是否推送到远程仓库？[Y/n]: " push_choice

    # 处理用户的输入
    switch $push_choice
        case '' y Y yes YES
            echo "🌐 正在推送到远程..."
            git push
            echo "✅ 推送完成！"
        case '*'
            echo "⏸️ 已跳过推送。你可以稍后手动 git push。"
    end
end
