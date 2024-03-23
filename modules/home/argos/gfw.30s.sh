#! /usr/bin/env bash

reachable () {
    http_code="$(curl --connect-timeout 15 -m 15 -o /dev/null -w "%{http_code}" "$1" 2> /dev/null)"

    if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 500 ]; then
        true
    else
        false
    fi
}

no_proxy() {
    @tproxy-bypass@ "$@"
}

if reachable "http://client3.google.com/generate_204"; then
    status="OK"
    full_status="Everything OK"
    icon_name="network-transmit-receive-symbolic"
elif reachable "http://g.cn/generate_204"; then
    status="PE"
    full_status="Proxy Error"
    icon_name="network-idle-symbolic"
elif no_proxy reachable "http://g.cn/generate_204"; then
    status="JE"
    full_status="Jumper Error"
    icon_name="network-error-symbolic"
else
    status="NE"
    full_status="Network Error"
    icon_name="network-offline-symbolic"
fi

echo "${status} | iconName=${icon_name}"
echo "---"
echo "$full_status"
echo "---"
echo "Manual test | iconName=google-symbolic href=http://google.com refresh=true"
