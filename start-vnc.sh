#!/bin/bash

set -e

# set the passwords for the user and the x11vnc session
# based on environment variables (if present), otherwise roll with
# the defaults from the Dockerfile build. 
#
if [ ! -z $emuhubPASS ] 
then
  echo "emuhub:$emuhubPASS" | chpasswd
fi

if [ ! -z $VNCPASS ] 
then
  echo "emuhub:$emuhubPASS" | chpasswd
  /usr/bin/vncpasswd -f <<< $VNCPASS > "/tmp/passwd"
  chmod go-rw /tmp/passwd
  chown emuhub:emuhub /tmp/passwd
  chown emuhub:emuhub /dev/kvm
fi

service xrdp start


sudo -u emuhub \
       	/usr/bin/tigervncserver -depth 24 -geometry 1920x1080  -passwd /tmp/passwd -SecurityTypes VncAuth &
sleep 2
sudo -u emuhub \
	pkill vncconfig 

echo "#!/bin/bash
cd /noVNC
./utils/novnc_proxy --listen $LISTENPORT --vnc localhost:5901" > /noVNC/start_proxy_command 
chmod ugo+x /noVNC/start_proxy_command
sudo -u emuhub /noVNC/start_proxy_command &

bash

wait
