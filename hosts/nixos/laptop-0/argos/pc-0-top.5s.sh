#! /usr/bin/env bash

export PATH="$HOME/.local/bin:$PATH"
status=$(ssh \
    -o ConnectTimeout=5 \
    -o ControlMaster=auto \
    -o ControlPath=~/.ssh/sockets/%r@%h-%p-argos-top \
    -o ControlPersist=60 \
    pc-0.ccat3z.xyz argos-top 2> /dev/null)
exit_code=$?

if [ "$exit_code" != 0 ]; then
    echo "\-\- | iconName=fan-stop-symbolic"
    echo "---"
    echo "$exit_code $status"
else
    echo "$status"
fi