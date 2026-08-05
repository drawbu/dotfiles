#!/usr/bin/env bash

input=$(cat)

# Parse everything in a single jq pass. Tab-separated so the model name
# (which contains spaces) survives the read. Rate limit fields are absent
# until the first API response of the session, hence the "--" fallbacks.
# resets_at is a unix timestamp, taken from the anthropic-ratelimit-*-reset
# response headers.
IFS=$'\t' read -r model ctx in_tok out_tok five_pct five_left week_pct week_left < <(
    jq -r '
        def pct: if type == "number" then "\(floor)" else "--" end;
        def compact:
            if type != "number" then "--"
            elif . >= 1000000 then "\(. / 100000 | floor / 10)M"
            elif . >= 1000 then "\(. / 100 | floor / 10)k"
            else tostring
            end;
        def remaining:
            if type != "number" then "--"
            else (. - now | floor) as $s
                | if $s <= 0 then "now"
                  elif $s >= 86400 then "\($s / 86400 | floor)d\($s % 86400 / 3600 | floor)h"
                  elif $s >= 3600 then "\($s / 3600 | floor)h\($s % 3600 / 60 | floor)m"
                  else "\($s / 60 | floor)m"
                  end
            end;
        [
            (.model.display_name // "--"),
            (.context_window.used_percentage | pct),
            (.context_window.total_input_tokens | compact),
            (.context_window.total_output_tokens | compact),
            (.rate_limits.five_hour.used_percentage | pct),
            (.rate_limits.five_hour.resets_at | remaining),
            (.rate_limits.seven_day.used_percentage | pct),
            (.rate_limits.seven_day.resets_at | remaining)
        ] | @tsv' <<<"$input"
)

orange=$'\e[38;2;217;119;87m'
green=$'\e[32m'
yellow=$'\e[33m'
red=$'\e[31m'
dim=$'\e[2m'
reset=$'\e[0m'

gauge() {
    local remaining=$1 percent=$2 color=$dim
    if [ "$percent" -ge 80 ]; then
        color=$red
    elif [ "$percent" -ge 50 ]; then
        color=$yellow
    fi
    printf '%s%s%s %s%s%%%s' "$dim" "$remaining" "$reset" "$color" "$percent" "$reset"
}

sep="  ${dim}-${reset}  "

limits=""
[ "$five_pct" != "--" ] && limits+=$(gauge "$five_left" "$five_pct")
[ "$week_pct" != "--" ] && limits+="${limits:+ }$(gauge "$week_left" "$week_pct")"

[ "$ctx" != "--" ] && ctx+="%"

line="${orange}${model}${reset} ${green}$(uname -n)${reset}"
[ -n "$limits" ] && line+="${sep}${limits}"
line+="${sep}${dim}ctx ${ctx} ↑${in_tok} ↓${out_tok}${reset}"

printf '%s' "$line"
