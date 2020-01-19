#!/bin/bash 
NS=`cat /etc/resolv.conf |grep search |awk '{print $2}'`
HOSTNAME0=`echo $HOSTNAME |awk -F\. '{print $1}' | sed 's/.$//'`
HOSTNAME1=`echo  ${HOSTNAME0}1.$NS`
HOSTNAME2=`echo  ${HOSTNAME0}2.$NS`
HOSTNAME_PID=`hostname -s`.pid
PRIV_IP1=`$GRID_HOME/bin/srvctl config nodeapps |grep "VIP IPv4" | awk  'NR==1{print $4}'`
PRIV_IP2=`$GRID_HOME/bin/srvctl config nodeapps |grep "VIP IPv4" | awk  'NR==2{print $4}'`
PUBLIC_IF=eth1
PRIVATE_IF=eth2

echo ""
echo "Disk Space : "
df

echo ""
echo "Major Clusterware Executable Protections : "
ls -l $GRID_HOME/bin/ohasd*
ls -l $GRID_HOME/bin/orarootagent*
ls -l $GRID_HOME/bin/oraagent*
ls -l $GRID_HOME/bin/mdnsd*
ls -l $GRID_HOME/bin/evmd*
ls -l $GRID_HOME/bin/gpnpd*
ls -l $GRID_HOME/bin/evmlogger*
ls -l $GRID_HOME/bin/osysmond.*
ls -l $GRID_HOME/bin/gipcd*
ls -l $GRID_HOME/bin/cssdmonitor*
ls -l $GRID_HOME/bin/cssdagent*
ls -l $GRID_HOME/bin/ocssd*
ls -l $GRID_HOME/bin/octssd*
ls -l $GRID_HOME/bin/crsd
ls -l $GRID_HOME/bin/crsd.bin
ls -l $GRID_HOME/bin/tnslsnr


echo ""
cmd="ping -c 2  $NS"
echo "Ping Nameserver: \$ $cmd  "; $cmd

echo ""
echo "Test your PUBLIC interface and your nameserver setup"
cmd="nslookup $HOSTNAME"
echo "\$ $cmd  "; $cmd
# nslookup $HOSTNAME

echo "Ping PUBLIC IPs: "
cmd="ping -I $PUBLIC_IF -c 2   $HOSTNAME1"
echo "\$ $cmd  "; $cmd
cmd="ping -I $PUBLIC_IF -c 2   $HOSTNAME2 "
echo "\$ $cmd  "; $cmd
echo ""
echo "Ping PRIVATE IPs: "
cmd="ping -I $PRIVATE_IF -c 2   $PRIV_IP1"
echo "\$ $cmd  "; $cmd
cmd="ping -I $PRIVATE_IF -c 2   $PRIV_IP2"
echo "\$ $cmd  "; $cmd

echo ""
echo "Verify protections for HOSTNAME.pid - all files should be : 644"
cmd="find $GRID_HOME -name $HOSTNAME_PID  -exec ls -l {} ; "
echo "\$ $cmd  "; $cmd

echo ""
echo "Service iptables and avahi-daemon should not run - avahi-daemon uses CW port 5353 "
cmd="service iptables status";
echo "\$ $cmd  "; $cmd
cmd="ps -elf "
echo "\$ $cmd |grep avahi | grep -v grep  "; $cmd |grep avahi | grep -v grep

echo ""
echo "Verify Clusterware Port Usage"
echo "Ports :53 :5353 :42422 :8888 should not be used by NON-Clusterware processes "
echo "  - OC4J reports : tcp   0 0 ::ffff:127.0.0.1:8888  :::*  LISTEN   501 67433979  2580/java"           
cmd='netstat -taupen '
echo "\$ $cmd  | egrep ':53 |:5353 |:42424 |:8888 '   "; $cmd | egrep ':53 |:5353 |:42424 |:8888 '

echo ""
echo "Compare profile.xml and the IP Address of PUBLIC and PRIVATE Interfaces "
echo " - Devices should report UP BROADCAST RUNNING MULTICAST "
echo " - Double check NETWORK addresses matches profile.xml settings   "
echo ""
# cmd="$GRID_HOME/bin/gpnptool get 2>/dev/null  |  xmllint --format - | egrep 'CSS-Profile|ASM-Profile|Network id' "
cmd="$GRID_HOME/bin/gpnptool get -o- "
echo "\$ $cmd  |   xmllint --format - | egrep 'CSS-Profile|ASM-Profile|Network id'  "; $cmd |   xmllint --format - | egrep 'CSS-Profile|ASM-Profile|Network id'
echo ""
cmd="ifconfig $PUBLIC_IF "
echo "\$ $cmd | egrep 'eth|inet addr|MTU'   "; $cmd | egrep 'eth|inet addr|MTU' 

echo ""
cmd="ifconfig $PRIVATE_IF "
echo "\$ $cmd | egrep 'eth|inet addr|MTU'   "; $cmd | egrep 'eth|inet addr|MTU' 

echo ""
echo "Checking ASM disk status for disk named /dev/asm ...  - you may need to changes this "
cmd="ls -l  /dev/oracleasm/asm*"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"
# ls -l  /dev/asm*

echo ""
echo "Verify ASM disk - read disk header locally  "

cmd="ssh ${HOSTNAME0}2 $GRID_HOME/bin/ocrcheck"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"
cmd="ssh ${HOSTNAME0}2  $GRID_HOME/bin/asmcmd lsdsk -k"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"

# su - oracle -c "ssh $HOSTNAME2 ocrcheck"
#su - oracle -c "ssh $HOSTNAME2  asmcmd lsdsk -k"
echo ""
cmd="kfed read /dev/oracleasm/asm-disk1 | grep name"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"

echo ""
cmd="kfed read /dev/oracleasm/asm-disk2 | grep name"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"

echo ""
cmd="kfed read /dev/oracleasm/asm-disk3 | grep name"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"

echo ""
cmd="kfed read /dev/oracleasm/asm-disk4 | grep name"
echo "\$ $cmd" ;  su - oracle -c   "$cmd"

