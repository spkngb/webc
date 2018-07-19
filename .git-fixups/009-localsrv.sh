#!/bin/sh

echo "Prepare our local website"
echo "Linking website dir as /var/www/html/ subdir"
ln -s /lib/live/mount/medium/www/desc /var/www/html/
