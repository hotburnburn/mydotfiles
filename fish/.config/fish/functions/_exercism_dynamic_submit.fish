function _exercism_dynamic_submit --description "Parse HELP.md for exercism submit"
    # 1. 如果连 HELP.md 都没有，直接给一个空的 submit 保底
    if not test -f HELP.md
        echo "exercism submit "
        return
    end

    # 2. 暴力又优雅地从 HELP.md 抓取！🎯
    # 逻辑：寻找 'exercism submit '，并捕获它后面直到遇到反引号 (`) 或换行符为止的所有字符
    # -r 开启正则，-g 表示只返回捕获组（括号里的内容）
    # [1] 确保就算文档里写了多次，我们也只取第一次匹配到的结果
    set -l files_to_submit (string match -r -g 'exercism submit ([^`\n\r]+)' < HELP.md)[1]

    # 3. 吐出最终结果
    if test -n "$files_to_submit"
        # 顺手把前后可能带的空格去掉，保证命令干净
        set files_to_submit (string trim "$files_to_submit")
        echo "exercism submit $files_to_submit"
    else
        # 万一正则没命中（比如官方某天突然改了文案），安全回退
        echo "exercism submit "
    end
end
