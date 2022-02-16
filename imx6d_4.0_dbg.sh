#!/bin/bash

if [ $# -eq 0 ]; then
	
	echo -e "\n\tScript Missing a parameter!!!\n"
	echo -e "\tusage:./imx6d_4.0_dbg.sh [parameter]\n\n\t\e[31mparameter:Automated or Manual\e[0m\n"
	exit 1
		
	else if [ $1 != "Automated" ] && [ $1 != "Manual" ]; then
	
			echo -e "\n\tparameter input error !!!\n"
			echo -e "\t\e[31mparameter:Automated or Manual\e[0m\n"
			exit 1
		 fi
fi
	
clear
echo -e "\n\033[32m *************   IAC-IMX6D-CM-TEST_V4.0_SCRIPT   *************\033[0m\n"

# Item_menu=("1 check RAM information" "2 check Disk information" "3 check Software version" \
			# "4 set & check RTC" "5 check USB & TF" "6 check BUZZER" "7 check Wired network" \
			# "8 check CAN communication" "9 check RS232 communication" "10 check 7 inch display" \
			# "11 check HDMI display" "12 check RS485 comunication" "E EXIT")
			
function network_obtains_current_time(){
		cd $PWD; if [ -e $PWD/beijing ]; then rm -rf $PWD/beijing; wget -q http://time.tianqi.com/beijing; else wget -q http://time.tianqi.com/beijing; fi
		Date_Time_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}'`
		Date_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $1}'`
		Time_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $2}'`
		year_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $1}' | awk -F "-" '{print $1}'`
		month_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $1}' | awk -F "-" '{print $2}'`
		day_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $1}' | awk -F "-" '{print $3}'`
		hour_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $2}' | awk -F ":" '{print $1}'`
		minute_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $2}' | awk -F ":" '{print $2}'`
		second_current=`cat beijing |grep -a "computed_time" |sed -n 1p |awk -F ">" '{print $5}'|awk -F "<" '{print $1}' |awk -F " " '{print $2}' | awk -F ":" '{print $3}'`
		rm -rf beijing
}

 # function display_menu(){
	# ROW=1
	# COW=5
	# item_menu=0
	# for ((i=0; i<=${#Item_menu[@]}; i++))
		# do
			# tput cup $ROW $COW
			# echo -e "\e[33m ${Item_menu[$item_menu]}\e[0m"
			# let item_menu++
			# let ROW++
		# done
	# return 0
# }

function menu(){
	cat <<-EOF
	************************************
	**  1  check RAM information      **
	**  2  check Disk information     **
	**  3  check Software version     **
	**  4  set & check RTC            **
	**  5  check USB & TF             **
	**  6  check BUZZER               **
	**  7  check Wired network        **
	**  8  check CAN communication    **
	**  9  check RS232 communication  **
	**  10 check 7 inch display       **
	**  11 check HDMI display         **
	**  12 check RS485 comunication   **
	**  E  End the test and exit      **
	************************************
	EOF
}

function Test_DDR_INFO(){
		clear
		echo -e "\033[32m***********   DDR_INFO  *************\033[0m\n"
		free -h
		DDR_total=`free -h |grep "Mem" |awk '{print $2}'` &> /dev/null
		DDR_available=`free -h |grep "Mem" |awk '{print $7}'` &> /dev/null
		}
					
function Test_EMMC_INFO(){
		clear
		echo -e "\033[32m************  EMMC_INFO  ************\033[0m\n"
		fdisk -l | grep "/dev/mmcblk*" | grep -v "/dev/mmcblk3boot"
		EMMC_total=`fdisk -l |grep "Disk /dev/mmcblk3:" |awk '{print $3}'` &> /dev/null
		}
				
function Test_OS_VERSION(){
		clear
		echo -e "\033[32m************  OS_VERSION  ************\033[0m\n"
		uname -a
		OS_VER_INFO=`uname -a |awk '{print $12"-"$8"-"$9" @ "$3}'` &> /dev/null
		}
				
function Test_RTC(){
		clear
		echo -e "\033[32m******** RTC testting......  *********\033[0m\n"

		if [ "$1" = "Automated" ]; then
			RTC_Test_Method=2
		else if [ "$1" = "Manual" ]; then
				echo -e "\033[36mTest mode selection:\033[0m\033[33m \n   1:Network calibration time  2:Local calibration time \033[0m"
				read -e -p "input you select: (1 or 2) " RTC_Test_Method
			fi
		fi
			case $RTC_Test_Method in
				1) 
					network_obtains_current_time
					RTC_set="${month_current}$》{day_current}${hour_current}${minute_current}${year_current}"
					date $RTC_set > /dev/null 2>&1 
					hwclock -w
					cd $PWD; sh ./rtc_test /dev/rtc
					;;
				2)
					if [ "$1" = "Automated" ]; then
						RTC_Time_Date_Calibrated=123123592022
						else
							read -e -p "input Time and date to be calibrated (eg: 123123592022 )"  RTC_Time_Date_Calibrated
					fi
					date $RTC_Time_Date_Calibrated
					hwclock -w
					cd $PWD; sh ./rtc_test /dev/rtc
					;;
			esac
			}
					
function Test_USB_TF(){
		clear
		echo -e "\033[32m******** USB & TF testting......  *********\033[0m\n"
		df -h | grep "/dev/sd*"
		df -h | grep "/dev/mmcblk*"|grep -v "/dev/mmcblk3p1"
		
		USB_num=1
		for usb in {a..f}
			do
				usbcapacity=` df -h |grep "/dev/sd${usb}1" |awk '{ print $2 }' `
				if [ $usbcapacity ]; then
					echo "The capacity of USB_${USB_num} is: ${usbcapacity}"
					USB_num=` expr $USB_num + 1 `
				fi
			done
		}
				
function Test_BUZZER(){
		clear
		echo -e "\033[32m********   BUZZER testting......  *********\033[0m\n"
		for loop in $( seq 2 );do ./buzzer_test /dev/qiyang_buzzer 1; sleep 2; \
		./buzzer_test /dev/qiyang_buzzer 0;sleep 2;done
		}
				
function Test_WIRED_NETWORK(){
		clear
		echo -e "\033[32m********  Wired_Network testting......   *********\033[0m\n"
		echo -ne "\033[32m `ifconfig eth0 | sed -n 1p | awk -F " "  '{print $1}'` \033[0m"
		echo -ne "\033[33m `ifconfig eth0 | sed -n 1p | awk -F " "  '{print $5}'`  \033[0m"
		echo -e "\033[33m `ifconfig eth0 | sed -n 2p | awk -F " "  '{print $2}'`\033[0m"

		if [ "$1" = "Automated" ]; then
			Wired_Test_Method=1
		fi
		
		if [ "$1" = "Manual" ]; then
				echo -e " \033[36m Test mode selection:\033[0m\033[33m 1:DHCP  2:STATIC \033[0m"
				read -e -p "input you select: (1 or 2) " Wired_Test_Method
		fi
		
		case $Wired_Test_Method in
			1)
				timeout 10 udhcpc -i eth0
				if [ $? -eq 0 ] ; then
					ping -c3 www.baidu.com
				else
				echo -e "\033[41;37m Network Exception,please check network connections or DNS \033[0m"
				echo -e "\033[41;36m DHCP test failed start STATIC test  \033[0m"
				sleep 3
				fi;;
			2)
				read -e -p"Please enter the IP address of the local computer(eg:192.168.X.X) " Local_Pc_Ip
				Network_Segment_Local_Computer=`echo $Local_Pc_Ip | awk -F "." '{print $1"."$2"."$3"."}'`
				Host_addr_Local_Computer=`echo $Local_Pc_Ip | awk -F "." '{print $4}'`
				IP_NEW_DEL=`expr $Host_addr_Local_Computer - 1`
				IP_NEW_ADD=`expr $Host_addr_Local_Computer + 1`
				if [ `expr $Host_addr_Local_Computer + 1` -gt 255 ] || \
								[ `expr $Host_addr_Local_Computer - 1` -lt 0 ]; then
					echo "\033[31m***The IP address is incorrect***\033[0m"
				else if [ `expr $Host_addr_Local_Computer + 1` -eq 255 ]; then
					ifconfig eth0  $Network_Segment_Local_Computer$IP_NEW_DEL
					 else if [ `expr $Host_addr_Local_Computer - 1` -eq 0  ]; then
						 ifconfig eth0 $Network_Segment_Local_Computer$IP_NEW_ADD
						  else
							ifconfig eth0 $Network_Segment_Local_Computer$IP_NEW_ADD
						  fi
					 fi
				fi
				ping -c3 $Local_Pc_Ip
				if [ $? -eq 0 ] ; then
					echo -e "\033[32m Network Test success \033[0m"
				else
					echo -e "\033[31m Network Exception \033[0m"
					echo -e "\033[31m Ensure that the IP address Settings are correct  \033[0m"
					echo -e "\033[31m check network connections,please \033[0m"
					sleep 5
				fi;;
		esac
		}
				
function Test_CAN(){
		clear
			echo -e "\033[32m******  CAN testting......   ***********\033[0m\n"
		echo -e "\033[34m J4_p1 connect J6_p3\n J6_p2 connect J6_p4\n \033[0m"
		
		ip link set can0 up type can bitrate 125000
		ip link set can1 up type can bitrate 125000
		sleep 2
		
		echo -e "\033[32m CAN0_recevier @ CAN1_send \033[0m"
		./can_test can0 0 > $PWD/can0_rx.log 2>&1 &
		./can_test can1 1 > $PWD/can1_tx.log 2>&1
		sleep 3
		wait
		IFS="\n"
		RX_CAN0=`grep "data" can0_rx.log |grep -v "can"`
		TX_CAN1=`grep "data" can1_tx.log |grep -v "can"`
		if [ "${RX_CAN0}" = "${TX_CAN1}" ]; then
				echo -e "\033[37m send_CAN1 @ receive_CAN0:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31mCAN0_Receive: ${RX_CAN0}\nCAN1_Send: ${TX_CAN1\n\033}[0m"
				echo -e "\033[37m send_CAN1 @ receive_CAN0:\033[0m\033[31m fail \n\n\033[0m"
		fi 
		
		echo -e "\033[32m CAN1_recevier @ CAN0_send \033[0m"
		./can_test can1 0 > $PWD/can1_rx.log 2>&1 &
		./can_test can0 1 > $PWD/can0_tx.log 2>&1
		wait
		
		RX_CAN1=`grep "data" can1_rx.log |grep -v can`
		TX_CAN0=`grep "data" can0_tx.log |grep -v can`
		if [ "${RX_CAN1}" = "${TX_CAN0}" ]; then
				echo -e "\033[37m send_CAN0 @ receive_CAN1:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31mCAN1_Receive: ${RX_CAN1}\nCAN0_Send: ${TX_CAN0}\n\033[0m"
				echo -e "\033[37m send_CAN0 @ receive_CAN1:\033[0m\033[31m fail \n\n\033[0m"
		fi
		IFS=" "
		mv $PWD/can0_rx.log $PWD/can0_tx.log $PWD/can1_rx.log $PWD/can1_tx.log /tmp
		}
				
function Test_RS232(){
		clear
		echo -e "\033[32m********   RS232 testting......  *********\033[0m\n"
		echo -e "\033[34m J6_p1 connect J6_p4\n J6_p2 connect J6_p3\n \033[0m"
		
		timeout 5 ./rs232_pressure_test /dev/ttymxc4 115200 20 > $PWD/rs232_ttymxc4.log 2>&1 &
		timeout 5 ./rs232_pressure_test /dev/ttymxc3 115200 20 > $PWD/rs232_ttymxc3.log 2>&1
		
		PACKETS_dev_ttymxc3_RX=`grep "Receive" $PWD/rs232_ttymxc3.log |sed -n 2p |awk '{print $2,$3,$4}'`
		PACKETS_dev_ttymxc4_TX=`grep "Send" $PWD/rs232_ttymxc4.log |sed -n 2p |awk '{print $2,$3,$4}'`
		if [ "${PACKETS_dev_ttymxc3_RX}" = "${PACKETS_dev_ttymxc4_TX}" ]; then
				echo -e "\033[37m 4_send_RS232 @ 3_receive_RS232:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31m${PACKETS_dev_ttymxc4_TX}  ${PACKETS_dev_ttymxc3_RX}\033[0m"
				echo -e "\033[37m 4_send_RS232 @ 3_receive_RS232:\033[0m\033[31m fail \n\n\033[0m"
		fi
		wait
		
		PACKETS_dev_ttymxc4_RX=`grep "Receive" $PWD/rs232_ttymxc4.log |sed -n 2p |awk '{print $2,$3,$4}'`
		PACKETS_dev_ttymxc3_TX=`grep "Send" $PWD/rs232_ttymxc3.log |sed -n 2p |awk '{print $2,$3,$4}'`
		if [ "${PACKETS_dev_ttymxc4_RX}" = "${PACKETS_dev_ttymxc3_TX}" ]; then
				echo -e "\033[37m 3_send_RS232 @ 4_receive_RS232:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31m${PACKETS_dev_ttymxc3_TX}  ${PACKETS_dev_ttymxc4_RX}\033[0m"
				echo -e "\033[37m 3_send_RS232 @ 4_receive_RS232:\033[0m\033[31m fail \n\n\033[0m"
		fi
		
		mv $PWD/PACKETS_dev_ttymxc4_RX.log $PWD/PACKETS_dev_ttymxc4_TX.log $PWD/PACKETS_dev_ttymxc3_RX.log  \
		$PWD/PACKETS_dev_ttymxc3_TX.log /tmp
		}
				
function Test_DISPLAY_7INCH_LVDS(){
		clear
		echo -e "\033[32m*******  display_7inch testting...... *******\033[0m\n"
		echo -e "\n Before the test, set parameters in the UBOOT:  \
		\n\nsetenv bootargs_mmc 'setenv bootargs ${bootargs} root=${mmcroot} rootwait rw  \
		video=mxcfb0:dev=ldb,LDB-WSVGA,if=RGB666 ldb=dul0 \n"
		ts_calibrate
		./Imx6_qt_test
		}
				
function Test_DISPLAY_HDMI_1080P(){
		clear
		echo -e "\033[32m*******  display_HDMI testting......  *******\033[0m\n"
		echo -e "\n Before the test, set parameters in the UBOOT:  \
		\n\n setenv bootargs_mmc 'setenv bootargs ${bootargs} root=${mmcroot} rootwait  \
		video=mxcfb0:dev=hdmi,1920x1080M@60,if=RGB24 video=mxcfb1:off video=mxcfb2:off \
		video=mxcfb3:off video=mxcfb4:off fec_mac=DC:07:C1:01:ff:f7' \n"
		./Imx6_qt_test
		}
				
function Test_RS485(){
		clear
		echo -e "\033[32m**********  RS485 testting......  **********\033[0m\n"
		echo -e "\n Before the test, set parameters in the UBOOT:  \
		\n\nsetenv bootargs_mmc 'setenv bootargs ${bootargs} root=${mmcroot} rootwait rw  rs485=3,4' \n"
		echo -e "\033[34m J6_p7 connect J6_p9;\n J6_p8 connect J6_p10;\n \033[0m"
		
		echo -e "\033[34m 3_send @ 4_receive \n\033[0m"
			timeout 3 ./rs485_pressure_test /dev/ttymxc4 115200 80 0 > $PWD/rs485_3TX_4RX_R.log 2>&1 & 
			timeout 3 ./rs485_pressure_test /dev/ttymxc3 115200 80 1 > $PWD/rs485_3TX_4RX_T.log 2>&1
			
		PACKETS_dev_ttymxc4_RX_34=`cat $PWD/rs485_3TX_4RX_R.log | grep "Receive"| awk '{print $3,$4}'`
		PACKETS_dev_ttymxc3_TX_34=`cat $PWD/rs485_3TX_4RX_T.log | grep "Send"| awk '{print $3,$4}'`
		if [ "${PACKETS_dev_ttymxc4_RX_34}" = "${PACKETS_dev_ttymxc3_TX_34}" ]; then
				echo -e "\033[37m 3_send @ 4_receive:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31mSend: ${PACKETS_dev_ttymxc3_TX_34}  Receive: ${PACKETS_dev_ttymxc4_RX_34}\033[0m"
				echo -e "\033[37m 3_send @ 4_receive:\033[0m\033[31m fail \n\n\033[0m"
		fi
		wait
		
		echo -e "\033[34m 4_send @ 3_receive \n\033[0m"				
			timeout 3 ./rs485_pressure_test /dev/ttymxc3 115200 80 0 > $PWD/rs485_4TX_3RX_R.log 2>&1 &
			timeout 3 ./rs485_pressure_test /dev/ttymxc4 115200 80 1 > $PWD/rs485_4TX_3RX_T.log 2>&1
			
		PACKETS_dev_ttymxc4_RX_43=`cat $PWD/rs485_4TX_3RX_R.log | grep "Receive"| awk '{print $3,$4}'`
		PACKETS_dev_ttymxc3_TX_43=`cat $PWD/rs485_4TX_3RX_T.log | grep "Send"| awk '{print $3,$4}'`
		if [ "${PACKETS_dev_ttymxc4_RX_43}" = "${PACKETS_dev_ttymxc3_TX_43}" ]; then
				echo -e "\033[37m 4_send @ 3_receive:\033[0m\033[32m success \033[0m"
			else
				echo "\033[31mSend: ${PACKETS_dev_ttymxc3_TX_43}  Receive: ${PACKETS_dev_ttymxc4_RX_43}\033[0m"
				echo -e "\033[37m 3_send @ 4_receive:\033[0m\033[31m fail \n\n\033[0m"
		fi
		wait
		
		mv $PWD/rs485_3TX_4RX_R.log $PWD/rs485_3TX_4RX_T.log $PWD/rs485_4TX_3RX_R.log $PWD/rs485_4TX_3RX_T.log /tmp
		}
				
function EXIT(){
		clear
		for NUM in `seq -w 3`
		do 
			read -e -p "Are you sure? [yes/no] " action
			if [ "$action" = "y" ] || [ "$action" = "Y" ] || [ "$action" = "YES" ] || [ "$action" = "yes" ]; then
				echo -e "\033[47;32mHappy at work every day!! \n***** GAME OVER!!! ****** \033[0m"
				echo -e "\n"; ls $PWD; echo -e "\n"
				exit 1
			else if [ "$action" = "n" ] || [ "$action" = "N" ] || [ "$action" = "NO" ] || [ "$action" = "no" ]; then
						echo -e "\033[37m\n continue testing !!! \n\033[0m" 
						break
					else 
						echo -e "\n\033[31m Input error, please enter again \n\033[0m"
				fi
			fi
		done
		
		if [ "$action" = "n" ] || [ "$action" = "N" ] || [ "$action" = "NO" ] || [ "$action" = "no" ]; then
			continue
		else
			echo -e "\n\033[41;37m The number of input errors exceeds three \033[0m"
		fi
		}
				
function Test_imx6d(){
		case $1 in
		
			1)
				Test_DDR_INFO
				;;
			2)
				Test_EMMC_INFO
				;;
			3)
				Test_OS_VERSION
				;;
			4)
				Test_RTC $2
				;;
			5)
				Test_USB_TF
				;;
			6)
				Test_BUZZER
				;;
			7)
				Test_WIRED_NETWORK $2
				;;
			8)
				Test_CAN
				;;
			9)
				Test_RS232
				;;
			10)
				Test_DISPLAY_7INCH_LVDS
				;;
			11)
				Test_DISPLAY_HDMI_1080P
				;;

			12)
				Test_RS485
				;;

			0)
				clear
				menu;;

			# 00)
				# clear
				# display_menu;;

			E)
				EXIT
				;;

			*)
				clear
				echo -e "\033[41;37m**********  select error  **********\033[0m"
				echo -e "\n"
				;;
		esac
		}
				
if [ $1 = "Manual" ]; then
	menu
	while :
		do 
			echo -en "\n\033[33mselect items:\033[0m\033[34m('0': display menu)  \033[0m"
			read -e Test_Num
			echo $Test_Num
			Test_imx6d $Test_Num $1
		done
	else
		for Test_Num in `seq 12`
			do
				echo -e "\n"
				Test_imx6d $Test_Num $1
				echo $Test_Num
			done
				
fi