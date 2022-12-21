#!/usr/bin/env bash
# This script helps to install klipper on orangepi devices

FlyingBearGhost5

sudo apt update -y
sudo apt upgrade -y


sudo visudo
klipper ALL=(ALL) NOPASSWD:ALL

sudo apt-get install gpiod sendemail libnet-ssleay-perl libio-socket-ssl-perl pmount -y
sudo apt-get install gpiod sendemail libnet-ssleay-perl libio-socket-ssl-perl -y
sudo apt-get install xorg xinit xserver-xorg-legacy libjpeg-dev zlib1g-dev python3-pip python3-dev libatlas-base-dev python3-gi-cairo python3-virtualenv gir1.2-gtk-3.0 virtualenv matchbox-keyboard wireless-tools xdotool xinput x11-xserver-utils libopenjp2-7 python3-distutils python3-gi python3-setuptools python3-wheel -y


sudo usermod -a -G tty klipper
sudo usermod -a -G dialout klipper
sudo adduser klipper sudo

sudo /bin/sh -c "cat > /etc/udev/rules.d/99-gpio.rules" <<EOF
# Corrects sys GPIO permissions so non-root users in the gpio group can manipulate bits
#
SUBSYSTEM=="gpio", GROUP="gpio", MODE="0660"
SUBSYSTEM=="gpio*", PROGRAM="/bin/sh -c '\
 chown -R root:gpio /sys/class/gpio && chmod -R 770 /sys/class/gpio;\
 chown -R root:gpio /sys/devices/virtual/gpio && chmod -R 770 /sys/devices/virtual/gpio;\
 chown -R root:gpio /sys$devpath && chmod -R 770 /sys$devpath\'"
EOF

sudo groupadd gpio
sudo usermod -a -G gpio klipper
sudo udevadm control --reload-rules
sudo udevadm trigger


crontab -e
0 05 * * * /home/klipper/backup_email.sh
* * * * * xset -display :0.0 dpms force on

sudo /bin/sh -c "cat > /etc/udev/rules.d/usbstick.rules" <<EOF
ACTION=="add", KERNEL=="sd[a-z][0-9]", TAG+="systemd", ENV{SYSTEMD_WANTS}="usbstick-handler@%k"
EOF

sudo /bin/sh -c "cat > /lib/systemd/system/usbstick-handler@.service" <<EOF
[Unit]
Description=Mount USB sticks
BindsTo=dev-%i.device
After=dev-%i.device

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/cpmount /dev/%I
ExecStop=/usr/bin/pumount /dev/%I
EOF

sudo /bin/sh -c "cat > /usr/local/bin/cpmount" <<EOF
#!/bin/bash
if mountpoint -q /media/timelapse
then
   if mountpoint -q /media/usb2
   then
      if mountpoint -q /media/usb3
      then
         if mountpoint -q /media/usb4
         then
             echo "No mountpoints available!"
             #You can add more if you need
         else
             /usr/bin/pmount --umask 000 --noatime -w --sync $1 usb4
         fi
      else
         /usr/bin/pmount --umask 000 --noatime -w --sync $1 usb3
      fi
   else
      /usr/bin/pmount --umask 000 --noatime -w --sync $1 usb2
   fi
else
   /usr/bin/pmount --umask 000 --noatime -w --sync $1 timelapse
fi
EOF

sudo chmod u+x /usr/local/bin/cpmount
sudo chmod +x /home/klipper/backup_email.sh
sudo armbian-add-overlay sun8i-h3-ads7846.dts

sudo /bin/sh -c "cat > /etc/X11/xorg.conf.d/99-calibration.conf" <<EOF
Section "InputClass"
        Identifier "ADS7846 Touchscreen"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
  Option    "SwapXY"    "1"
  Option    "InvertX"   "1"
EndSection
EOF

cd ~
git clone https://github.com/th33xitus/kiauh.git
./kiauh/kiauh.sh

FlyingBearGhost5

sudo mcedit /etc/systemd/system/klipper.service

sudo mcedit /etc/systemd/system/moonraker.service

sudo mcedit /etc/systemd/system/moonraker-telegram-bot.service

sudo mcedit /usr/local/bin/webcamd

sudo mcedit /etc/X11/xorg.conf.d/01-armbian-defaults.conf
Section "Monitor"
        Identifier "HDMI-1"
        Option "Rotate" "left"
EndSection
Section "ServerFlags"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime"  "0"
EndSection


cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
bash ~/moonraker-timelapse/install.sh

cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
bash ~/moonraker-timelapse/install.sh





Flying Bear Ghost 6

sudo apt update
sudo apt install git build-essential linux-headers-current-sunxi

git clone https://github.com/Sergey1560/fb_st7796s.git
cd fb_st7796s/kernel_module/

make
sudo make install
make clean
sudo depmod -A

sudo bash -c 'echo "fb_st7796s" >> /etc/initramfs-tools/modules'
sudo update-initramfs -u



sudo cp /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb.bak
sudo dtc -b 0 -O dts -I dtb -o /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dts /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dtb
sudo mcedit /boot/dtb/allwinner/sun50i-h6-orangepi-3-lts.dts



sudo cp /boot/dtb/sun8i-h2-plus-orangepi-zero.dtb /boot/dtb/sun8i-h2-plus-orangepi-zero.dtb.bak
sudo dtc -b 0 -O dts -I dtb -o /boot/dtb/sun8i-h2-plus-orangepi-zero.dts /boot/dtb/sun8i-h2-plus-orangepi-zero.dtb
sudo mcedit /boot/dtb/sun8i-h2-plus-orangepi-zero.dts

default-state = "off";
linux,default-trigger = "mmc0";

sudo dtc -b 0 -O dtb -I dts -o /boot/dtb/sun8i-h2-plus-orangepi-zero.dtb /boot/dtb/sun8i-h2-plus-orangepi-zero.dts


sudo cp /boot/dtb/sun8i-h3-orangepi-pc.dtb /boot/dtb/sun8i-h3-orangepi-pc.dtb.bak
sudo dtc -b 0 -O dts -I dtb -o /boot/dtb/sun8i-h3-orangepi-pc.dts /boot/dtb/sun8i-h3-orangepi-pc.dtb
sudo mcedit /boot/dtb/sun8i-h3-orangepi-pc.dts

default-state = "off";
linux,default-trigger = "mmc0";

sudo dtc -b 0 -O dtb -I dts -o /boot/dtb/sun8i-h3-orangepi-pc.dtb /boot/dtb/sun8i-h3-orangepi-pc.dts

sudo armbian-add-overlay sun8i-h3-ads7846.dts

sudo apt install xinput-calibrator

sudo /bin/sh -c "cat > /etc/X11/xorg.conf.d/99-calibration.conf" <<EOF
Section "InputClass"
        Identifier      "calibration"
        MatchProduct    "ADS7846 Touchscreen"
        Option  "MinX"  "66064"
        Option  "MaxX"  "1075"
        Option  "MinY"  "2559"
        Option  "MaxY"  "62430"
        Option  "SwapXY"        "0" # unless it was already set to 1
        Option  "InvertX"       "0"  # unless it was already set
        Option  "InvertY"       "0"  # unless it was already set
EndSection
EOF

sudo /bin/sh -c "cat > /etc/udev/rules.d/51-touchscreen.rules" <<EOF
#DISPLAY=:0.0 xinput --set-prop 'ADS7846 Touchscreen' 'Coordinate Transformation Matrix' 1 0 0 0 -1 1 0 0 1
ACTION=="add", ATTRS{name}=="ADS7846 Touchscreen", ENV{LIBINPUT_CALIBRATION_MATRIX}="1 0 0 0 -1 1 0 0 1"
EOF



sudo /bin/sh -c "cat > /boot/overlay-user/sun8i-h3-ili9486.dts" <<EOF

EOF

#sudo armbian-add-overlay /boot/overlay-user/sun8i-h3-ili9486_tp.dts


sudo /bin/sh -c "cat > /home/klipper/backup_email.sh" <<EOF
#!/bin/bash
USER='klipper'
NONE=' '
versions(){
  cd /home/$USER/klipper/
  Klipper=$(git describe HEAD --always --tags | cut -d "-" -f 1,2)
  cd /home/$USER/moonraker/
  git fetch origin master -q
  Moonraker=$(git describe HEAD --always --tags | cut -d "-" -f 1,2)
  if [ -e /home/$USER/mainsail/.version ]; then
    Mainsail=$(head -n 1 /home/$USER/mainsail/.version)
  else
    Mainsail=$NONE
  fi
  if [ -e /home/$USER/fluidd/.version ]; then
    Fluidd=$(head -n 1 /home/$USER/fluidd/.version)
  else
    Fluidd=$NONE
  fi
  if [ -d /home/$USER/KlipperScreen ] && [ -d /home/$USER/KlipperScreen/.git ]; then
    cd /home/$USER/KlipperScreen/
    git fetch origin master -q
    KlipperScreen=$(git describe HEAD --always --tags | cut -d "-" -f 1,2)
  else
    KlipperScreen=$NONE
  fi
  if [ -d /home/$USER/moonraker-telegram-bot ] && [ -d /home/$USER/moonraker-telegram-bot/.git ]; then
    cd /home/$USER/moonraker-telegram-bot/
    git fetch origin master -q
    MoonrakerTelegramBot=$(git describe HEAD --always --tags | cut -d "-" -f 1,2)
  else
    MoonrakerTelegramBot=$NONE
  fi
  cd ~
}
data=`date +%Y.%m.%d`
read -r printers < /etc/hostname
if [ "$printers" == "FlyingBearGhost5" ]; then
  printer='Flying Bear Ghost 5'
  names='BackUp_Flying_Bear_Ghost_5_'$data'.zip'
elif [ "$printers" == "Ender3Pro" ]; then
  printer='Ender 3 Pro'
  names='BackUp_Ender_3_Pro_'$data'.zip'
else
  printer='No Name '$printers
  names='BackUp_No_Name_'$data'.zip'
fi
versions
tema='Backup '$data' Printer '$printer
msg='\nKlipper : '$Klipper' \nMoonraker : '$Moonraker'\nMainsail : '$Mainsail' \nFluidd : '$Fluidd' \nKlipperScreen : '$KlipperScreen' \nMoonraker Telegram Bot : '$MoonrakerTelegramBot'\n'
echo -e $msg
zip -r /home/$USER/$names klipper_config/* .moonraker_database/* klipper/out/klipper.bin klipper/.config backup_email.sh # Делаем бэкап
FROM=sis.8727@gmail.com			# Будет отображаться "От кого"
MAILTO=5796630@mail.ru			# Кому
SMTPSERVER=smtp.gmail.com:587
SMTPLOGIN=sis.8727@gmail.com	# Логин и пароль от учетной записи gmail.com
SMTPPASS=brtvozeirrlbqrfc
# Отправляем письмо
/usr/bin/sendEmail -f $FROM -t $MAILTO -o message-charset=utf-8 -a /home/$USER/$names -u $tema -m $msg -s $SMTPSERVER -o tls=yes -xu $SMTPLOGIN -xp $SMTPPASS
rm /home/$USER/$names		# Удаляем файл backup
EOF



Try this:

sudo mcedit /etc/X11/xorg.conf.d/01-armbian-defaults.conf
Section "Monitor"
        Identifier "HDMI-1"
        Option "Rotate" "left"
EndSection
Section "ServerFlags"
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime"  "0"
EndSection



normal(0)/right(90)/inverted(180)/left(270)
sudo /bin/sh -c "cat > /lib/systemd/system/getty@tty1.service.d/20-autologin.conf" <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin klipper --noclear %I $TERM
EOF

sudo /bin/sh -c "cat > /etc/X11/Xwrapper.config" <<EOF
allowed_users=anybody
needs_root_rights=yes
EOF

1 0 0 
0 1 0 
0 0 1

0 -1 1 
1 0 0 
0 0 1

0 1 0 -1 0 1 0 0 1

-1 0 1 0 -1 1 0 0 1