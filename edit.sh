#!/bin/bash

puppetserver_key='son.nt@ltv.dev'
recipient_file='gpg_recipients'

if [ $# -ne 1 ]; then
    echo "[-] Please specify a file to edit.."
    exit 1
fi

grep $puppetserver_key $recipient_file > /dev/null || { echo "ERROR: ${puppetserver_key} not in recipient file ${recipient_file}. This may NEVER happen!"; exit 1; }

if [ ! -e $1 ]; then
    echo "[*] Specified file argument $1 does not exist, creating it for you..."
    touch $1
fi

echo -e "[*] Importing new public keys..."
gpg --import gpg_pubkeys/*

echo -e "[*] Editing the following file: $1"
echo -e "[*] Recipients are:"
cat $recipient_file
echo ""

eyaml edit --gpg-always-trust --gpg-recipients-file $recipient_file $1