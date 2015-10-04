#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
	
print() {
		printf "$1 $2 ${NC}\n"
}

bin=`which fastboot | awk '{ print \$1 }'`
if [ -z $bin ]; then
	echo Could not locate your fastboot binary. Try placing it in your \$PATH.
	exit 1
fi
cat <<HEADER
             Created by Georgii Savatkov
	       Script to flash your device with full firmware
                                    -
                 Version: 1.0  FastBoot Type: Fastboot
                                    -
              Have fun! Tested on Moto X 2 Gen.
                                    -
           Press any key to start fastboot erase, or Ctrl+C to abort!
HEADER
read

echo '[Running Commands...]'
echo '[Checking for phone...]'
devs=`$bin devices | grep fastboot | wc -l`
if [ $devs -ge 1 ]; then
	ser=`$bin devices | awk '{ print \$1 }'`
	echo -e "\nI was able to find a device with fastboot serial of $ser\n"
	echo Any key to continue, or Ctrl+C to abort
	read


	print $NC "Flashing partition..."
	$bin flash partition ./gpt.bin
	print $GREEN "Done" # done
	print $NC "Flashing motoboot..."
	$bin flash motoboot ./motoboot.img
	print $GREEN "Done" #done
	print $NC "Rebooting device..."
	$bin reboot-bootloader
	print $GREEN "Done" #done
	print $NC "Flashing logo..."
	$bin flash logo ./logo.bin
	print $GREEN "Done" #done
	print $NC "Flashing boot..."
	$bin flash boot ./boot.img
	print $GREEN "Done" #done
	print $NC "Flashing recovery..."
	$bin flash recovery ./recovery.img
	print $GREEN "Done" #done
	echo "Flashing system..."
	for i in {0..8}
	do
   		/Users/george/Downloads/mfastboot-v2/mfastboot flash system ./system.img_sparsechunk.$i 
   		print $GREEN "Done" #done
	done
	print $GREEN "Done" #done
	print $NC "Erasing previous bands..."
	$bin erase modemst1
	$bin erase modemst2
	print $GREEN "Done" #done
	$bin flash fsg ./fsg.mbn
	print $GREEN "Done" #done
	$bin flash modem ./NON-HLOS.bin
	print $GREEN "Done" #done
	$bin erase userdata 
	$bin erase cache
	print $GREEN "Done" #done
	print $NC "Rebooting device..." #reboot
	$bin reboot
	print $GREEN "Done! Have fun, your device is ready" #done
	exit 0
else 
	print $RED "Didn't detect a phone in fastboot mode, exiting"
	exit 1
fi

