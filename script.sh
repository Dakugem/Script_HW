#!/bin/bash
while true 
do 	
	clear
	first_lines_of_ps_aux=`ps aux --sort=-%cpu | head -n 2`
	process_pid=`echo "$first_lines_of_ps_aux" | awk '{print $2}' | tail -n 1`
	#process_pid=`ps aux --sort=-%cpu  | grep -Pom 1 "[[:space:]]\K([[:digit:]]){1,5}(?=[[:space:]])"| head -n 1`

	proc_PID_dir=`ls -al /proc/$process_pid 2> /dev/null`
	if [ $? -ne 0 ]
	then
		second_line_of_ps_aux=`echo "$first_lines_of_ps_aux" | tail -n 1`

		echo "Uid: ?"
		echo "User: `echo "$second_line_of_ps_aux" | awk '{print $1}'`"
		echo "Pid: $process_pid"
		echo "Name: ?"
		echo "State: ?"
		echo "CMD: `echo "$second_line_of_ps_aux" | awk '{print $11}'`"
		echo "PR: ?"
		echo "NI: ?"
		echo "%CPU: `echo "$second_line_of_ps_aux" | awk '{print $3}'`"
		echo "%MEM: `echo "$second_line_of_ps_aux" | awk '{print $4}'`"
		echo "Start: `echo "$second_line_of_ps_aux" | awk '{print $9}'`"
		echo "Time: `echo "$second_line_of_ps_aux" | awk '{print $10}'`"
		echo "VIRT: `echo "$second_line_of_ps_aux" | awk '{print $5}'`"
		echo "RES: `echo "$second_line_of_ps_aux" | awk '{print $6}'`"
		
		echo "У этого процесса нет папки /proc/$process_pid"
	else
		second_line_of_ps_aux=`echo "$first_lines_of_ps_aux" | tail -n 1`
		uid=`echo $(cat /proc/$process_pid/status | grep "Uid" | awk '{print $2}')`
		
		echo "Uid: $uid"
		#Можно было конечно взять user name из строчки aux, но можно и так
		echo "User: `cat /etc/passwd | grep "x:$uid:" | awk -F ":" '{print $1}'`"
		echo "Pid: $process_pid"
		echo "$(cat /proc/$process_pid/status | grep -P "Name|State")"
		echo "CMD: `echo "$second_line_of_ps_aux" | awk '{print $11}'`"
		echo "PR: $(cat /proc/$process_pid/stat | awk '{print $18}')"
		echo "NI: $(cat /proc/$process_pid/stat | awk '{print $19}')"
		echo "%CPU: `echo "$second_line_of_ps_aux" | awk '{print $3}'`"
		echo "%MEM: `echo "$second_line_of_ps_aux" | awk '{print $4}'`"
		echo "Start: `echo "$second_line_of_ps_aux" | awk '{print $9}'`"
		echo "Time: `echo "$second_line_of_ps_aux" | awk '{print $10}'`"
		echo "VIRT: $(cat /proc/$process_pid/status | grep -P "VmSize" | awk '{print $2, $3}')"
		echo "RES: $(cat /proc/$process_pid/status | grep -P "VmRSS" | awk '{print $2, $3}')"
		cat /proc/$process_pid/io
		cat /proc/$process_pid/limits
	fi
	sleep 5
done 
