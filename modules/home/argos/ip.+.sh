#! /usr/bin/env bash

echo "| iconName=ip-symbolic"
echo "---"

if [ "$ARGOS_MENU_OPEN" == "true" ]; then
    ip addr | sed -nE 's#^ *inet ([0-9\./]*) .*$#\1#p'
fi
