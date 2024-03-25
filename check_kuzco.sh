if pgrep -x "kuzco-runtime" > /dev/null
then
   top -b -n 1|grep --count 'kuzco'
   echo "kuzco-runtime is running."
else
    echo "kuzco-runtime is not running. Killing all kuzco processes..."
    killall kuzco
    for i in {1..29}; do (nohup kuzco worker start > /dev/null 2>&1 & sleep 3); done
fi
