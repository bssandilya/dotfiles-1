# Screw all this, let's just fucking make these on the fly
# Same as screen, I cannot fucking figure out how to launch a process
# that'll drop me back into bash if I ^C it.

echo "#! /usr/bin/env bash
sudo service memcached stop
sudo service mysql stop
sudo apache2ctl stop
sudo /opt/lampp/lampp restart
sudo /opt/lampp/memcached/bin/memcached -m 100 -d -u nobody -l 127.0.0.1
sudo su - -c 'cd /opt/lampp'
/usr/bin/env bash
" > /tmp/lampp_start

echo "#! /usr/bin/env bash
tail -n 0 -f /opt/lampp/htdocs/mobilityserver/log/*.log
/usr/bin/env bash
" > /tmp/log_ms

echo "#! /usr/bin/env bash
tail -n 0 -f /opt/lampp/htdocs/csmobility/log/*.log
/usr/bin/env bash
" > /tmp/log_msadmin

echo "#! /usr/bin/env bash
tail -n 0 -f /opt/lampp/logs/error_log
/usr/bin/env bash
" > /tmp/log_error

echo "#! /usr/bin/env bash
echo 0 is $0
echo 1 is $1
#cd $0
/usr/bin/env bash
" > /tmp/cd

echo "#! /usr/bin/env bash
while [ ! -e /opt/lampp/var/mysql/mysql.sock ]; do 
    echo Sleeping until mysql wakes up; sleep 10; 
done;
/opt/lampp/bin/mysql -uroot mobilityserver
/usr/bin/env bash
" > /tmp/mysql_ms

echo "#! /usr/bin/env bash
while [ ! -e /opt/lampp/var/mysql/mysql.sock ]; do 
    echo Sleeping until mysql wakes up; sleep 10; 
done;
/opt/lampp/bin/mysql -uroot netowem
/usr/bin/env bash
" > /tmp/mysql_msadmin

chmod u+x /tmp/lampp_start   \
          /tmp/log_ms        \
          /tmp/log_msadmin   \
          /tmp/log_error     \
          /tmp/mysql_ms      \
          /tmp/mysql_msadmin \
          /tmp/cd

if ! tmux has-session -t netomat 1>/dev/null 2>/dev/null; then
    # Create new session with a window that starts lampp
    tmux new-session -d -s netomat -n 'lampp' "/usr/bin/env bash /tmp/lampp_start"

    # Log window
    tmux new-window -n "logs" "/usr/bin/env bash /tmp/log_ms"
    # Split this into panes, each of which follows a different set of logs
    tmux split-window -v -p 45 "/usr/bin/env bash /tmp/log_msadmin"
    tmux split-window -v -p 10 "/usr/bin/env bash /tmp/log_error"


    # Mobility Server and MSAdmin
    tmux new-window -d -n "mobilityserver" "/usr/bin/env bash -c /tmp/cd /opt/lampp/htdocs/mobilityserver/"
    tmux new-window -d -n "msadmin"        "/usr/bin/env bash -c /tmp/cd /opt/lampp/htdocs/csmobility/"

    # mysql
    tmux new-window -d -n "ms mysql"      "/usr/bin/env bash -c '/opt/lampp/bin/mysql -uroot mobilityserver; /bin/bash'"
    tmux new-window -d -n "msadmin mysql" "/usr/bin/env bash -c '/opt/lampp/bin/mysql -uroot netowem; /bin/bash'"    

    tmux select-window -t netomat:mobilityserver

fi

# Clean up
rm /tmp/lampp_start   \
   /tmp/log_ms        \
   /tmp/log_msadmin   \
   /tmp/log_error     \
   /tmp/mysql_ms      \
   /tmp/mysql_msadmin \
   /tmp/cd
   

# Attach
tmux attach -t netomat


