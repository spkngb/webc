#!/bin/sh

echo "Fixing mysql permissions"
mkdir -vp /var/log/mysql/
touch /var/log/mysql/error.log
chown mysql:adm /var/log/mysql/
chown mysql:adm /var/log/mysql/*
chmod 755 /var/log/mysql/
chmod 660 /var/log/mysql/*
