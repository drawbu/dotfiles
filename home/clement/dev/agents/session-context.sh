#!/usr/bin/env bash

if jj root &>/dev/null; then
    jj_root=$(jj root)

    if [ -d "$jj_root/local/repos" ]; then
        echo "== Local repos (./local/repos)"
        ls "$jj_root/local/repos"
    fi

    echo "== Recent changes (jj log -r 'ancestors(@, 10)')"
    jj log -r 'ancestors(@, 10)' --no-pager

    echo "== Current changes (jj diff --stat)"
    jj diff --stat --no-pager
fi
