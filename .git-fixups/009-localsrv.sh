#!/bin/sh

echo "Linking website dir as /var/www/html/ subdir"
ln -s /lib/live/mount/medium/www/desc /var/www/html/
cd /lib/live/mount/medium/ && mkdir -vp www

echo "Adding /sbin/localsrv-sync as cron task for updating website data"
test -f /etc/cron.d/localsrv-sync || ( echo '*/15 * * * * root sh -c /sbin/localsrv-sync' > /etc/cron.d/localsrv-sync ; echo "Added cron task" ; )

echo "Local website should be ready for work after first sync"
date
uptime
