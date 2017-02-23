#!/bin/sh

PROMPT_COMMAND='echo -ne "\033]0;R1 HD AMAZON BOOTLOADER UNLOCK\007"'
set -e



sleep 5000
echo "We will first start with adb devices, to make sure you can connect to the phone.

It should look something like:

List of devices attached
**************** device

Where the ***s are replaced with your phones serial number. If nothing is displayed, exit script with ctrl c, check your connection, make sure your phone is on, etc, and try again. "

read -p "Press enter to continue"

adb start-server
adb devices


read -p "Press enter if your device showed up, else ctrl c to exit"

echo "Copying dirtycow to /data/local/tmp/dirtycow"
adb push pushed/dirtycow /data/local/tmp/dirtycow
echo "Copying recowvery-app_process32 to /data/local/tmp/recowvery-app_process32"
adb push pushed/recowvery-app_process32 /data/local/tmp/recowvery-app_process32
echo "Copying frp.bin to /data/local/tmp/unlock"
adb push pushed/frp.bin /data/local/tmp/unlock
echo "Copying busybox to /data/local/tmp/busybox"
adb push pushed/busybox /data/local/tmp/busybox
echo "Copying cp_comands.txt to /data/local/tmp/cp_comands.txt"
adb push pushed/cp_comands.txt /data/local/tmp/cp_comands.txt
echo "Copying dd_comands.txt to /data/local/tmp/dd_comands.txt"
adb push pushed/dd_comands.txt /data/local/tmp/dd_comands.txt
echo "Changing permissions on copied files"
adb shell chmod 0777 /data/local/tmp/*

echo "DONE PUSHING FILES TO PHONE. NOW WE ARE GOING TO TEMP WRITE OVER THE APP_PROCESS WITH A MODIFIED VERSION THAT HAS lsh IN IT USING A SYSTEM-SERVER AS ROOT SHELL. THIS STEP WILL CAUSE PHONE TO DO A SOFT REBOOT AND WILL NOT RESPOND TO BUTTON PUSHES"

read -p "Press enter to continue"

adb shell /data/local/tmp/dirtycow /system/bin/app_process32 /data/local/tmp/recowvery-app_process32

echo "
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
Waiting 60 seconds for root shell to spawn. While app_process is replaced, phone will appear to be unresponsive, but the shell is working"

sleep 60

echo "OPENING A ROOT SHELL ON THE NEWLY CREATED SYSTEM_SERVER
MAKING A DIRECTORY ON PHONE TO COPY FRP PARTION TO
CHANGING PERMISSIONS ON NEW DIRECTORY
COPYING FPR PARTION TO NEW DIRECTORY AS ROOT
CHANGING PERMISSIONS ON COPIED FRP"

adb shell "/data/local/tmp/busybox nc localhost 11112 < /data/local/tmp/cp_comands.txt"

echo "COPYING UNLOCK.IMG OVER TOP OF COPIED FRP IN /data/local/test NOT AS ROOT WITH DIRTYCOW

"

adb shell /data/local/tmp/dirtycow /data/local/test/frp /data/local/tmp/unlock

echo "waiting 5 sec before writing FRP to EMMC"
sleep 5
echo "DD COPY THE NEW (UNLOCK.IMG) FROM /data/local/test/frp TO PARTITION mmcblk0p17"

adb shell "/data/local/tmp/busybox nc localhost 11112 < /data/local/tmp/dd_comands.txt"

echo "
-------------------------------------------------------------------
-------------------------------------------------------------------
-------------------------------------------------------------------
REBOOTING_INTO_BOOTLOADER
"
read -p "Press enter to continue"
adb reboot bootloader

echo.--------------------------------------------------------------------------------------------
echo.--------------------------------------------------------------------------------------------
echo "YOUR PHONE SCREEN SHOULD BE BLACK WITH THE WORD "=>FASTBOOT mode..." IN LOWER CORNER
JUST LIKE IN THE BEGINING WE NEED TO VERIFY YOU HAVE DRIVERS ON PC FOR THE NEXT STEP
THE RESPONSE SHOULD BE

***************     fastboot

THE STARS WILL BE YOUR SERIAL NUMBER
IF THE RESPONSE IS THIS THEN HIT ANY BUTTON ON PC TO CONTINUE

IF RESPONSE IS A BLANK LINE YOU DO NOT HAVE DRIVER NEEDED TO CONTINUE. CLOSE THIS WINDOW
AND GET FASTBOOT DRIVERS THEN EITHER RUN "fastboot oem unlock" IN TERMINAL"
fastboot devices

read -p "Press enter to continue"

echo "NOW THAT THE DEVICE IS IN FASTBOOT MODE WE ARE GOING TO UNLOCK THE
BOOTLOADER. ON THE NEXT SCREEN ON YOUR PHONE YOU WILL SEE
PRESS THE VOLUME UP/DOWN BUTTONS TO SELECT YES OR NO
JUST PRESS VOLUME UP TO START THE UNLOCK PROCESS.
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
"
read -p "Press enter to start the unlock"
fastboot oem unlock

read -p "ONCE THE BOOTLOADER IS UNLOCKED PRESS ENTER TO WIPE DATA"
fastboot format userdata
::cls
read -p "PRESS ENTER TO REBOOT THE DEVICE"
fastboot reboot

echo "--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
YOUR BOOTLOADER IS NOW UNLOCKED ON YOUR BLU R1 HD AMAZON DEVICE
FIRST BOOT UP WILL TAKE AROUND 5 TO 10 MINUTES THEN YOU CAN SET IT UP
NEXT IS TO INSTALL RECOVERY TWRP


YOU WILL NEED TO ENBLE DEVELOPERS OPTION, THEN ENABLE ADB TO CONTINUE NEXT SCRIPT
******************
IF PHONE DID NOT REBOOT HOLD POWER UNTILL IT POWERS OFF THEN AGAIN TO POWER ON
******************
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
"

read -p "PRESS ENTER TO INSTALL TWRP AFTER YOU ENABLE DEVELOPER OPTIONS ON PHONE
OR CTRL+C TO STOP HERE"

echo "--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-----------REBOOTING_INTO_BOOTLOADER--------------------------------------------------------
"
adb reboot bootloader
echo "--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
NOW YOUR IN FASTBOOT MODE AND READY TO FLASH TWRP RECOVERY



--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
"
read -p "PRESS ENTER TO FLASH RECOVERY"
fastboot flash recovery pushed/recovery.img

echo "ONCE THE FILE TRANSFER IS COMPLETE HOLD VOLUME UP AND PRESS ENTER ON PC
IF PHONE DOES NOT REBOOT THEN HOLD VOLUME UP AND POWER UNTILL IT DOES
pause"
fastboot reboot
echo "ON PHONE SELECT RECOVERY FROM BOOT MENU WITH VOLUME KEY THEN SELECT WITH POWER"

read -p "PRESS ENTER ON PC FOR MORE NOTES"
echo "--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
NOW YOU BOOTED TO RECOVERY CONTINUE AND MAKE A BACKUP IF YOU WANT
YOU CAN JUST CONTINUE AS IS FROM HERE OR FLASH THE OLD PRELOADER FILE WITH
RECOVERY. THERE ARE MORE STEPS NOT INCLUDED HERE IF YOU WANT TO DO THAT.

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
"
read -p "PRESS ENTER TO FINISH THIS SCRIPT."
exit 0
