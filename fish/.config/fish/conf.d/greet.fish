function fish_greeting
    if command -v fortune >/dev/null; and command -v cowsay >/dev/null; and command -v lolcat >/dev/null
        fortune | cowsay | lolcat
    else
        fortune | cowsay
    end
end
