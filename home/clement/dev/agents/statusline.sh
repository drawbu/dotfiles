#!/usr/bin/env bash

input=$(cat)

# Parse everything in a single jq pass. Tab-separated so the model name
# (which contains spaces) survives the read. Rate limit fields are absent
# until the first API response of the session, hence the "--" fallbacks.
IFS=$'\t' read -r model used in_tok out_tok five_h week < <(
    jq -r '[
        .model.display_name,
        (.context_window.used_percentage // "--"),
        .context_window.total_input_tokens,
        .context_window.total_output_tokens,
        (.rate_limits.five_hour.used_percentage // "--"),
        (.rate_limits.seven_day.used_percentage // "--")
    ] | @tsv' <<<"$input"
)

line="$model | ctx: ${used}% | in/out: ${in_tok}/${out_tok}"
[ "$five_h" != "--" ] && line+=" | 5h: ${five_h%.*}%"
[ "$week" != "--" ] && line+=" | 7d: ${week%.*}%"

printf '%s' "$line"
