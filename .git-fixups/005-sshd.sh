#!/bin/sh

echo "Fixing sshd permissions"
chmod 600 /etc/ssh/ssh_host_*
chmod 644 /etc/ssh/ssh_host_*.pub
chmod 600 /root/.ssh/config
chmod 600 /root/.ssh/authorized_keys
chmod 600 /root/.ssh/known_hosts
