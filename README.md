# 监控并重启kuzco脚本
自动检测kuzco状态并重启。包含多开

## 1.进入wsl
先获得root权限
然后
<!--sec data-title="OS X и Linux" data-id="OSX_Linux_whoami" data-collapse=true ces-->
```
su
```
在Password:输入root密码
<!--endsec-->
## 2.创建脚本。
创建一个脚本，根据自己显卡能力，更改29这个数值。我是4090，所以开29个worker

<!--sec data-title="OS X и Linux" data-id="OSX_Linux_whoami" data-collapse=true ces-->
```
cat > /root/check_ionet.sh <<EOF 
#!/bin/bash
workers=29#根据自己gpu能力，更改此数值
if pgrep -x "kuzco-runtime" > /dev/null
then
   top -b -n 1|grep --count 'kuzco'
   echo "kuzco-runtime is running."
else
    echo "kuzco-runtime is not running. Killing all kuzco processes..."
    killall kuzco
    for ((i=0;i<workers;i++)); do (nohup kuzco worker start > /dev/null 2>&1 & sleep 3); done
fi
EOF
```
<!--endsec-->
复制上述代码，直接粘贴到命令行。

## 3.修改脚本权限
<!--sec data-title="OS X и Linux" data-id="OSX_Linux_whoami" data-collapse=true ces-->
```
chmod +x /root/check_kuzco.sh
```
<!--endsec-->
## 4.可以先运行一下，可以看到脚本正在运行。
<!--sec data-title="OS X и Linux" data-id="OSX_Linux_whoami" data-collapse=true ces-->
```
/root/check_kuzco.sh
```
<!--endsec-->
![image](https://github.com/hbnnwwt/restart_kuzco/assets/116838445/040aa49d-eac6-4f11-af15-5c33c336a3ab)
跑了29个worker，还有一个是kuzco-runtime

## 5.将脚本加入到定时运行。
<!--sec data-title="OS X и Linux" data-id="OSX_Linux_whoami" data-collapse=true ces-->
```
crontab<<EOF
HOME=/root/
*/5 * * * * check_kuzco.sh
EOF
```
<!--endsec-->

最后，不建议kuzco和ionet同一台机器同时开。感觉有点互斥。
