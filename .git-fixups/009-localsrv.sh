#!/bin/sh

# bash variant
# wait_file() {
#   local file="$1"; shift
#   local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout
#
#   until test $((wait_seconds--)) -eq 0 -o -f "$file" ; do sleep 1; done
#
#  ((++wait_seconds))
#} ;

# sh variant
wait_file() {
  local file="$1"; shift
  local wait_seconds="${1:-10}"; shift # 10 seconds as default timeout

  until test "$wait_seconds" -eq 0 -o -f "$file" ; do wait_seconds=$(($wait_seconds - 1)); sleep 1; done

  wait_seconds=$(($wait_seconds + 1));
} ;

echo "Prepare our local website"
date
uptime

echo "Testing for local storage writeability"
testdir=/lib/live/mount/medium/www/test
rndnum=$(date +%N|sed s/...$//)
testfile=$testdir/testfile_${rndnum}.txt

rm -vf "$testfile"
rmdir -v "$testfile"

( until [ -f "$testfile" ]
do
  mkdir -vp "$testdir"
  touch "$testfile"
  date >> "$testfile"
  uptime >> "$testfile"
  sleep 1
done ; ) &

timeout=60

wait_file "$testfile" "$timeout" && {
  echo "File is found after $? seconds before ${timeout:-10} seconds timed out: '$testfile'"
} || {
  echo "File is not found after waiting for ${timeout:-10} seconds: '$testfile'"
} ;

rm -vf "$testfile"
rmdir -v "$testfile"

echo "Linking website dir as /var/www/html/ subdir"
ln -s /lib/live/mount/medium/www/desc /var/www/html/
cd /lib/live/mount/medium/ && mkdir -vp www

echo "Syncing website mysql data from repo"
cd /lib/live/mount/medium/www/ && git clone https://github.com/spkldr/desc-data.git desc-data
cd /lib/live/mount/medium/www/desc-data/ && ( git reset --hard ; git reset --mixed ; git checkout master ; git pull ; )

echo "Syncing website static files from repo"
cd /lib/live/mount/medium/www/ && git clone https://github.com/spkldr/desc.git desc
cd /lib/live/mount/medium/www/desc/ && ( git reset --hard ; git reset --mixed ; git checkout master ; git pull ; )

echo "Waiting creation of mysql unix socket"
testfile=/var/run/mysqld/mysqld.sock
timeout=60

wait_file "$testfile" "$timeout" && {
  echo "File is found after $? seconds before ${timeout:-10} seconds timed out: '$testfile'"
} || {
  echo "File is not found after waiting for ${timeout:-10} seconds: '$testfile'"
} ;

echo "Testing connection to mysql with unix socket"
mysql -u root <<EOC

SELECT USER(), CURRENT_USER() ;
SHOW GRANTS ;

EOC

echo "Recreating root user for mysql with password login"
mysql -u root <<EOC

SELECT USER(), CURRENT_USER() ;

SHOW GRANTS ;
FLUSH PRIVILEGES ;
SELECT \`user\`, \`host\`, \`password\`, \`password_expired\`,\`Grant_priv\` FROM \`mysql\`.\`user\` WHERE \`User\` = 'root';

CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'mysql' ;
SELECT \`user\`, \`host\`, \`password\`, \`password_expired\`,\`Grant_priv\` FROM \`mysql\`.\`user\` ;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY PASSWORD '*E74858DB86EBA20BC33D0AECAE8A8108C56B17FA' WITH GRANT OPTION ;

GRANT PROXY ON ''@'%' TO 'root'@'127.0.0.1' WITH GRANT OPTION ;

SHOW GRANTS ;
FLUSH PRIVILEGES ;
SELECT \`user\`, \`host\`, \`password\`, \`password_expired\`,\`Grant_priv\` FROM \`mysql\`.\`user\` ;

DROP USER 'root'@'localhost' ;

SHOW GRANTS ;
FLUSH PRIVILEGES ;
SELECT \`user\`, \`host\`, \`password\`, \`password_expired\`,\`Grant_priv\` FROM \`mysql\`.\`user\` ;

QUIT ;

EOC

echo "Testing connection to mysql with tcp socket"
mysql -u root -h 127.0.0.1 -pmysql --protocol=TCP <<EOC

SELECT USER(), CURRENT_USER() ;
SHOW GRANTS ;

EOC

echo "Recreating mysql database for website"
mysql -u root -h 127.0.0.1 -pmysql --protocol=TCP <<EOC

SELECT USER(), CURRENT_USER() ;

DROP DATABASE IF EXISTS \`desc\` ;

CREATE DATABASE IF NOT EXISTS \`desc\` ;

USE \`desc\` ;

SHOW TABLES ;

EOC

echo "Importing website mysql data from repo to new database"
mysql -u root -h 127.0.0.1 -pmysql desc < /lib/live/mount/medium/www/desc-data/desc.sql

echo "Testing connection to mysql new database with tcp socket"
mysql -u root -h 127.0.0.1 -pmysql --protocol=TCP desc <<EOC

SELECT USER(), CURRENT_USER() ;

SHOW TABLES ;

EOC

echo "Adding self as cron task for updating website data"
test -f /etc/cron.d/localsrv-sync || ( echo '*/15 * * * * root sh -c /.git-fixups/009-localsrv.sh' > /etc/cron.d/localsrv-sync ; killall firefox ; )

echo "Local website should be ready for work"
