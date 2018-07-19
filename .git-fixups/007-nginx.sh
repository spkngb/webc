#!/bin/sh

echo "Fixing nginx permissions"
mkdir -vp /var/log/nginx/
touch /var/log/nginx/access.log
touch /var/log/nginx/error.log
chown root:adm /var/log/nginx/
chown www-data:adm /var/log/nginx/*
chmod 755 /var/log/nginx/
chmod 640 /var/log/nginx/*
