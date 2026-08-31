#!/usr/bin/env bash

input=$(cat)

# Parse everything in a single jq pass. Tab-separated so the model name
# (which contains spaces) survives the read. Rate limit fields are absent
# until the first API response of the session, hence the "--" fallbacks.
# resets_at is a unix timestamp, taken from the anthropic-ratelimit-*-reset
# response headers.
IFS=$'\t' read -r model ctx in_tok out_tok five_pct five_left week_pct week_left cost session_id session < <(
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
            (.rate_limits.seven_day.resets_at | remaining),
            (.cost.total_cost_usd // 0),
            (.session_id // ""),
            (.session_name // "")
        ] | @tsv' <<<"$input"
)

orange=$'\e[38;2;217;119;87m'
green=$'\e[32m'
yellow=$'\e[33m'
red=$'\e[31m'
dim=$'\e[2m'
bold=$'\e[1m'
reset=$'\e[0m'

# Twelve hues at one luminance, so a hashed host stays as readable as a named
# one. The 256-colour cube is the obvious hash target and half of it is
# illegible on one background or the other.
host_palette=(
    '208;93;93' '178;115;52' '133;133;39' '92;143;41'
    '43;148;43' '42;146;94' '41;143;143' '65;133;200'
    '119;119;216' '158;104;211' '203;75;203' '206;87;146'
)

host=$(uname -n)
case $host in
    lucy) host_rgb='51;152;93' ;;
    maine) host_rgb='213;76;85' ;;
    rebecca) host_rgb='85;149;206' ;;
    kiwi) host_rgb='176;140;41' ;;
    *)
        host_hash=$(printf '%s' "$host" | cksum | cut -d' ' -f1)
        host_rgb=${host_palette[host_hash % ${#host_palette[@]}]}
        ;;
esac
host_color=$'\e[38;2;'${host_rgb}m

# --ignore-working-copy skips the snapshot, which the PostToolUse hook already
# takes. Without it the status line blocks on the working copy lock on every
# refresh.
jj_section=""
if IFS=$'\t' read -r id_prefix id_rest ins del < <(jj log -r @ --no-graph --color=never \
    --ignore-working-copy -T 'change_id.shortest(8).prefix() ++ "\t" ++ change_id.shortest(8).rest()
        ++ "\t" ++ diff.stat().total_added() ++ "\t" ++ diff.stat().total_removed() ++ "\n"' 2>/dev/null); then
    jj_section="${bold}${id_prefix}${reset}${dim}${id_rest}${reset}"
    if [ "$ins" != 0 ] || [ "$del" != 0 ]; then
        jj_section+=" ${green}+${ins}${reset} ${red}-${del}${reset}"
    fi
fi

gauge() {
    local remaining=$1 percent=$2 color=$dim
    if [ "$percent" -ge 80 ]; then
        color=$red
    elif [ "$percent" -ge 50 ]; then
        color=$yellow
    fi
    printf '%s%s%s %s%s%%%s' "$dim" "$remaining" "$reset" "$color" "$percent" "$reset"
}

# Neither the extra usage flag nor the credit spend reaches the status line, so
# a window reading 100 stands in for "past the plan" and the cost is the
# client-side list price estimate, not the amount actually billed.
extra=""
if [ -n "$session_id" ] && { [ "$five_pct" = 100 ] || [ "$week_pct" = 100 ]; }; then
    baseline="${XDG_RUNTIME_DIR:-/tmp}/claude-cost-$session_id"
    [ -f "$baseline" ] || printf '%s' "$cost" >"$baseline"
    extra=$(awk -v now="$cost" '{ if (now - $0 >= 0.005) printf "+$%.2f", now - $0 }' "$baseline")
fi

sep="  ${dim}-${reset}  "

limits=""
[ "$five_pct" != "--" ] && limits+=$(gauge "$five_left" "$five_pct")
[ "$week_pct" != "--" ] && limits+="${limits:+ }$(gauge "$week_left" "$week_pct")"

[ "$ctx" != "--" ] && ctx+="%"

line="${orange}${model}${reset}"
[ -n "$limits" ] && line+="${sep}${limits}"
[ -n "$extra" ] && line+=" ${yellow}${extra}${reset}"
line+="${sep}${dim}ctx ${ctx} ↑${in_tok} ↓${out_tok}${reset}"
line+=$'\n'"${host_color}${host}${reset}"
[ -n "$session" ] && line+="${sep}${dim}${session}"
[ -n "$jj_section" ] && line+="${sep}${jj_section}${reset}"

printf '%s' "$line"
