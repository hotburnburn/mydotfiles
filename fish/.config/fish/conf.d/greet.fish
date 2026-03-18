function fish_greeting
    if test "$TERM_PROGRAM" = vscode
        return
    end

    # 刚好 4 个选项，摇 1 到 4 的随机数
    set -l lucky_number (random 1 4)

    switch $lucky_number
        case 1
            # 1. 炫彩 Cowsay (经典带文字气泡的牛)
            if command -v fortune >/dev/null; and command -v cowsay >/dev/null; and command -v lolcat >/dev/null
                fortune | cowsay | lolcat
            else if command -v fortune >/dev/null; and command -v cowsay >/dev/null
                fortune | cowsay
            end

        case 2
            # 2. Fastfetch (极客风系统信息)
            if command -v fastfetch >/dev/null
                fastfetch
            else
                echo "💻 Ready to code!"
            end

        case 3
            # 3. 盆栽 (终端禅意)
            if command -v cbonsai >/dev/null
                # -p 表示直接打印出来不带动画，避免每次打开终端都要等它长完
                cbonsai -p
            else
                echo "🌿 Keep Calm and Code On"
            end

        case 4
            # 4. 炫彩艺术短句 (每次不同的话)
            if command -v fortune >/dev/null; and command -v figlet >/dev/null; and command -v lolcat >/dev/null
                # 使用 -s 参数确保只抽取短句，防止 figlet 排版炸裂
                fortune -s | figlet | lolcat
            else if command -v figlet >/dev/null; and command -v lolcat >/dev/null
                # 如果没装 fortune，就固定显示一句问候
                echo "Hello Fish!" | figlet | lolcat
            end
    end
end
