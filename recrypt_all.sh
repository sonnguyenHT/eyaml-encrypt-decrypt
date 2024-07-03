#!/bin/bash

if [ $# -eq 0 ]; then
    encrypted_files=`grep -Rl "ENC\[GPG" *`
else
    encrypted_files=$*
fi
puppetserver_key='son.nt@ltv.dev'
recipient_file='gpg_recipients'

grep $puppetserver_key $recipient_file > /dev/null || { echo "ERROR: ${puppetserver_key} not in recipient file ${recipient_file}. This must NEVER happen!"; exit 1; }

echo -e "[*] Reencrypting the following files:\n $encrypted_files\n"
echo -e "[*] Recipients are:"
cat $recipient_file
echo ""

for item in $encrypted_files ; do
    echo "[*] Reencrypting $item"
    eyaml recrypt --gpg-always-trust --gpg-recipients-file $recipient_file $item
    if [ $? -eq 0 ] ; then
        echo -e "[+] Successfully reencrypted $item\n"
    else
        echo "[-] Reencryption of $item failed, this is bad!"
        echo "[-] Please investigate what went wrong and DO NOT PUSH THIS!!"
        exit 1
    fi
done
echo "[+] Reencryption of all files was successful"