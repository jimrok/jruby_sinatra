#! /bin/sh
### BEGIN INIT INFO
# Provides:          jruby server
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the ewhine_search server
# Description:       starts jruby server using start-stop-daemon
### END INIT INFO


PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON="/usr/lib/jvm/java-7-oracle/jre/bin/java"
DESC=app_push

min_heap_size="128m"
max_heap_size="512m"

serverdir=/home/ewhine/deploy/app_push
serverjar=server.jar
server_temp=$serverdir/tmp
server_logs=$serverdir/log
server_name="ewhine_search"
PIDFILE=$server_temp/$server_name.pid
USER=ewhine
DB_ENV=production

test -x $DAEMON || exit 0
test -x $serverdir || exit 0

set -e

ARGS="-server -Xms$min_heap_size -Xmx$max_heap_size -XX:PermSize=128m -Xloggc:$server_logs/gc.log -XX:+PrintGCTimeStamps -XX:-PrintGCDetails -Drack.env=production -Djava.awt.headless=true -jar $serverjar"
case "$1" in
  start)
	echo -n "Starting $DESC... "
	touch $PIDFILE
        chown "$USER" $PIDFILE
	if start-stop-daemon --start --chdir $serverdir --quiet --make-pidfile --background --pidfile $PIDFILE --chuid "$USER" --exec $DAEMON -- $ARGS
	then
		echo "done."
	else
		echo "failed"
	fi
	;;
  stop)
	echo -n "Stopping $DESC... "
	if start-stop-daemon --stop --retry 10 --quiet --pidfile $PIDFILE
	then
		echo "done."
	else
		echo "failed"
	fi
	rm -f $PIDFILE
	;;

  restart|force-reload)
	${0} stop
	${0} start
	;;
  *)
	echo "Usage: /etc/init.d/$server_name {start|stop|restart|force-reload}" >&2
	exit 1
	;;
esac

exit 0