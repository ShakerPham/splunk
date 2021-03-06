# !bin/bash

#Change hostname
    
     hostnamectl set-hostname SPLUNK

#Disable SE Linux
    setenforce 0

#Edit limits config
    sed -i "\$a * soft   nofile   200000" /etc/security/limits.conf
    sed -i "\$a * hard   nofile   200000" /etc/security/limits.conf
 
#Edit enviromment
    sed -i "\$a ip route add 172.16.5.0\/24 dev ens192 src 172.16.5.50 table rt2"  /etc/rc.d/rc.local
    sed -i "\$a ip route add default via 172.16.5.1 dev ens192 table rt2" /etc/rc.d/rc.local
    sed -i "\$a ip rule add from 172.16.5.50\/32 table rt2" /etc/rc.d/rc.local
    sed -i "\$a ip rule add to 172.16.5.50\/32 table rt2" /etc/rc.d/rc.local

    sed -i "\$a #disable THP at boot time" /etc/rc.d/rc.local

     sed -i "\$a if test -f \/sys\/kernel\/mm\/transparent_hugepage\/enabled;then\necho never > /sys/kernel/mm/transparent_hugepage/enabled\nfi\nif test -f /sys/kernel/mm/transparent_hugepage/defrag; then\necho never > /sys/kernel/mm/transparent_hugepage/defrag\nfi\n" >/etc/rc.d/rc.local
#Create ssh
    echo "# !/bin/bash
    echo \"-----------------------------------------------\" 
    echo \"Hi $LOGNAME, you are login from $SSH_CONNECTION\"
    export SPLUNK_HOME=/home/splunk
    " > /etc/profile.d/splunk.sh
    

#Get splunk
    wget -O splunk.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.0.0&product=splunk&filename=splunk-7.0.0-c8a78efdd40f-Linux-x86_64.tgz&wget=true'

#MD5 checksum
    code=64b0b7dded3bf12ed3f4b344d8612070
    code_current=`md5sum splunk.tgz | cut -b -32`
#Check sum
    if [[ "$code_current" == "$code" ]];then
        #Install splunk
            #Untaring
            tar -zxvf splunk.tgz -C /home
            
            #Move to setup
            cd /home/splunk/bin
            
            #run splunk setup
            ./splunk start --accept-license
            ./splunk enable boot-start 
    else
        echo "File is corrupted."
    fi
    
#Define variables home
    export SPLUNK_HOME=/home/splunk
  



















