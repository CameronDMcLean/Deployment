#
# Script Name: DellSwitch.sh
# Created by Cameron McLean for personal use
#
# Script to retrieve SNMP values from Dell switches (2848, 5448, 2824) and report to influxdb for use in Grafana

#
# To-Do: 
# - Add network stats (throughput, latency)
# -

#The time we are going to sleep between readings, in seconds. Note this is at the end of the script so total time elapsed will include script runtime
#ie if runtime is 2s then total time between reads will be 12s
sleeptime=10

echo "Press [CTRL+C] to stop..."
#start loop
while :
do


	#Sample snmpget
	#Don't forget the index location, .0 in this case, at the end of the OID
	snmp_uptime=`snmpget -v 2c -c 'SNMPAdmin' 192.168.1.7 DISMAN-EVENT-MIB::sysUpTimeInstance -Ov`
	#Memory usage last minute
	#Bandwidth usage
	#Latency?
	#Temperature, seems a little high. Test?
	Temp=`snmpget -v 2c -c 'SNMPAdmin' 192.168.1.7 RADLAN-Physicaldescription-MIB::rlPhdUnitEnvParamTempSensorValue.1 -Ov`
	#CPU utilization last second
	CPULastSec=`snmpget -v 2c -c 'SNMPAdmin' 192.168.1.7 RADLAN-rndMng::rlCpuUtilDuringLastSecond.0 -Ov`
	#CPU utilization last minute
	CPULastMin=`snmpget -v 2c -c 'SNMPAdmin' 192.168.1.7 RADLAN-rndMng::rlCpuUtilDuringLastMinute.0 -Ov`


	#Format output, -c is the number of characters to remove
	snmp_uptime=$(echo $snmp_uptime | cut -c 10-)
	Temp=$(echo $Temp | cut -c 10-)
	CPULastSec=$(echo $CPULastSec | cut -c 10-)
	CPULastMin=$(echo $CPULastMin | cut -c 10-)

	#Display value to write
	echo "snmp_uptime: $snmp_uptime"
	echo "Temp: $Temp"
	echo "CPULastSec: $CPULastSec%"
	echo "CPULastMin: $CPULastMin%"

	#Write to influxdb
	curl -i -XPOST 'YOUR_INFLUXDB_SERVER' --data-binary "snmpdb,host=YOUR_HOST,type=uptime value=$snmp_uptime"
	curl -i -XPOST 'YOUR_INFLUXDB_SERVER' --data-binary "snmpdb,host=YOUR_HOST,type=Temp value=$Temp"
	curl -i -XPOST 'YOUR_INFLUXDB_SERVER' --data-binary "snmpdb,host=YOUR_HOST,type=CPULastSec value=$CPULastSec"
	curl -i -XPOST 'YOUR_INFLUXDB_SERVER' --data-binary "snmpdb,host=YOUR_HOST,type=CPULastMin value=$CPULastMin"
   
   #Wait for a bit before checking again
   sleep "$sleeptime"

   done