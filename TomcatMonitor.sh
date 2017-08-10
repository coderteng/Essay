#!/bin/bash

set -e
set -x

LOGNAME="/home/tomcat_monitor.log"
TOMCAT_ARRAY=(tomcat2 tomcat8 tomcat9)

if [[ ! -f ${LOGNAME} ]];then
	touch ${LOGNAME}
fi	

proc_num()
{
        number=$(ps -ef | grep $1 | grep -v grep | wc -l)
}

proc_id()
{
        current_pid=$(ps -ef | grep $1 | grep -v grep | awk '{print $2}')
}

while :
do

	for tomcat_name in ${TOMCAT_ARRAY[@]}
	do
		proc_num ${tomcat_name}

		if [ $number -eq 0 ]; then

			cd /usr/local/${tomcat_name}/bin/ 
			./startup.sh

			proc_id ${tomcat_name}

			echo "[ $(date) ] ${tomcat_name} is Restarted" >>  ${LOGNAME}
			echo "After the restart,the PID is ${current_pid}" >>  ${LOGNAME}
		fi
	done  

	sleep 10s
done
~    
