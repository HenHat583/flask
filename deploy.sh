#! /bin/bash
pgrep flask
if [[ "$?" == 0 ]] ; then
  sudo pkill flask
fi
cd flask
sudo nohup flask run --host=0.0.0.0 &
sleep 3