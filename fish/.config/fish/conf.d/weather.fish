# ==========================================
# ⛅️ 异步天气缓存 (Open-Meteo 稳定版)
# ==========================================
function _update_weather_cache
    # 1. 强制 IPv4 请求 Open-Meteo API，获取当前天气 JSON
    set -l json_data (curl -4 -s "https://api.open-meteo.com/v1/forecast?latitude=32.03&longitude=118.93&current_weather=true&timezone=Asia%2FShanghai")

    # 如果网络彻底断了没拿到数据，直接静默退出
    if test -z "$json_data"
        return
    end

    # 获取当前小时（0-23，去除前导零）
    set current_hour (date +%-H)

    # 2. 用 jq 提取温度（并四舍五入）和 WMO 天气代码
    set -l temp (echo $json_data | jq '.current_weather.temperature | round')
    set -l code (echo $json_data | jq '.current_weather.weathercode')

    # 3. 把枯燥的数字代码变成好看的 Emoji
    set -l icon "🌡️"
    switch $code
        case 0
            # 判断是白天还是夜晚（这里假设 6:00 到 17:59 为白天）
            if test $current_hour -ge 6 -a $current_hour -lt 18
                set icon "🌞"
            else
                set icon "🌙"
            end
        case 1 2
            set icon "⛅"
        case 3
            set icon "☁ "
        case 45 48
            set icon "🌫️"
        case 51 53 55 56 57 61 63 65 66 67 80 81 82
            set icon "☔"
        case 71 73 75 77 85 86
            set icon "⛄"
        case 95 96 99
            set icon "⚡"
    end

    # 4. 组装并写入你的临时文件
    echo "$icon $temp°C" >/tmp/weather_cache.txt
end

# 触发条件不变：文件不存在，或超过 30 分钟没更新
if test -f /tmp/weather_cache.txt
    set -l last_modified (stat -c %Y /tmp/weather_cache.txt 2>/dev/null; or stat -f %m /tmp/weather_cache.txt 2>/dev/null)
    set -l now (date +%s)
    if test (math "$now - $last_modified") -gt 3600
        _update_weather_cache &
    end
else
    _update_weather_cache &
end
