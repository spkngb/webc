#!/bin/sh

echo "Fixing mysql permissions"
mkdir -vp /var/log/mysql/
touch /var/log/mysql/error.log
chown mysql:adm /var/log/mysql/
chown mysql:adm /var/log/mysql/*
chmod 755 /var/log/mysql/
chmod 660 /var/log/mysql/*
mkdir -vp /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql/
chmod 700 /var/lib/mysql/
