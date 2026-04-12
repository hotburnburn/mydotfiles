function exercism --description "Wrapper for exercism with auto-setup and VSCode integration"
    # 1. 如果不是 download 命令，直接放行给原生的 exercism CLI
    if test "$argv[1]" != download
        command exercism $argv
        return
    end

    # 2. 执行原生的下载命令
    command exercism $argv
    set -l download_status $status

    if test $download_status -ne 0
        return $download_status
    end

    # 3. 提取 track 和 exercise 名称 (带上 -- 防护栏)
    set -l track (string match -r -g -- '--track=(.*)' $argv)
    set -l exercise (string match -r -g -- '--exercise=(.*)' $argv)

    if test -n "$track"; and test -n "$exercise"
        set -l workspace_dir (command exercism workspace)
        set -l target_dir "$workspace_dir/$track/$exercise"

        # 4. 自动进入目录
        if test -d "$target_dir"
            echo "✨ 自动进入目录: $target_dir"
            cd "$target_dir"

            # 准备传给 VSCode 的参数数组，默认一定要打开当前目录 '.'
            set -l code_args .
            set -a code_args README.md

            # 5. 特定语言的初始化逻辑
            if test "$track" = haskell
                # 初始化环境
                if test -f "package.yaml"
                    echo "🛠️ 检测到 Haskell 环境，正在初始化..."
                    stack build --only-configure
                end

                # 自动寻找 src 目录下的 Haskell 源码文件
                set -l hs_files src/*.hs
                if test (count $hs_files) -gt 0
                    echo "📄 锁定源文件: $hs_files[1]"
                    # 将找到的第一个文件追加到 VSCode 参数中
                    set -a code_args $hs_files[1]
                end
            end

            if test "$track" = typescript
                corepack yarn install
            end

            # ✨ 新增：Python 环境初始化逻辑
            if test "$track" = python
                echo "🐍 检测到 Python 环境，正在使用 uv 初始化..."

                # 1. 创建虚拟环境 (如果不存在)
                if not test -d .venv
                    uv venv
                end

                # 2. 强制指定安装到当前目录的 .venv 中
                echo "📦 正在极速安装测试依赖..."
                if uv pip install --python .venv pytest pytest-cache pytest-subtests
                    echo "✅ 依赖安装成功！"
                else
                    echo "❌ 依赖安装失败，请检查网络！"
                end

                # 3. 创建 pytest.ini 消除自定义 marker 警告
                if not test -f pytest.ini
                    echo "⚙️ 自动生成 pytest.ini 配置文件..."
                    printf "[pytest]\nmarkers =\n    task: A concept exercise task.\n" >pytest.ini
                end

                # 4. 🤖 自动配置 VSCode 测试 (免除手动点击)
                echo "🪄 注入 VSCode 测试配置..."
                if not test -d .vscode
                    mkdir .vscode
                end
                # 直接将配置写入 settings.json
                echo '{
    "python.testing.pytestArgs": [
        "."
    ],
    "python.testing.unittestEnabled": false,
    "python.testing.pytestEnabled": true
}' >.vscode/settings.json

            end

            # 6. 智能打开 VSCode
            if set -q TERM_PROGRAM; and test "$TERM_PROGRAM" = vscode
                echo "💻 在集成终端中，复用当前窗口..."
                code -r $code_args
            else
                echo "💻 打开新的 VSCode 窗口..."
                code $code_args
            end
        end
    end
end
