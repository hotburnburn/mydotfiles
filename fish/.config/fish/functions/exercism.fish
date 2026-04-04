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
