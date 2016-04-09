#!/usr/bin/env bash

function usage_and_exit {
    echo "Usage: $0 <server>" 1>&2
    echo "" 1>&2
    echo "<server> is one of:" 1>&2
    for servername in `ls servers/`; do
        echo "  ${servername}" 1>&2
    done
    echo "" 1>&2
    exit 1
}

if ! type ansible-playbook >/dev/null 2>&1; then
    echo "ansible-playbook is not found in PATH" 1>&2
    exit 1
fi

if test $# -lt 1; then
    usage_and_exit
fi

SERVER=$1
shift

HOSTSFILE="servers/${SERVER}/hosts"
VARFILE="servers/${SERVER}/configuration.yml"

for filename in ${HOSTSFILE} ${VARSFILE}; do
    if ! test -f ${filename}; then
        echo "File \"${filename}\" not found" 1>&2
        echo "Is server name \"${SERVER}\" correct?" 1>&2
        exit 1
    fi
done

if test ${SERVER} == "vagrant"; then
    EXTRA="--private-key=.vagrant/machines/default/virtualbox/private_key"
else
    EXTRA=""
fi

if ! ansible-playbook ${EXTRA} -i ${HOSTSFILE} -e "@${VARFILE}" "$@" deploy.yml; then
    exit 1
fi
