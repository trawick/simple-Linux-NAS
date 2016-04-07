#!/usr/bin/env bash

usage="Usage: $0 {production|vagrant}"
if test $# -lt 1; then
    echo $usage 1>&2
    exit 1
fi

SERVER=$1
shift

case $SERVER in
    production)
        HOSTSFILE=hosts
        VARFILE=vars.yml
        EXTRA=""
        ;;
    vagrant)
        HOSTSFILE=vagrant_hosts
        VARFILE=vagrant_vars.yml
        EXTRA="--private-key=.vagrant/machines/default/virtualbox/private_key"
        ;;
    *)
        echo $usage 1>&2
        exit 1
esac

if ! ansible-playbook $EXTRA -i $HOSTSFILE -e "@$VARFILE" deploy.yml; then
    exit 1
fi
