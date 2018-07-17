#!/bin/sh

echo "Fixing sshd permissions"
chmod 600 /etc/ssh/ssh_host_*
chmod 644 /etc/ssh/ssh_host_*.pub
