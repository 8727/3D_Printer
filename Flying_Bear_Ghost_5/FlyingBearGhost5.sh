#!/usr/bin/env bash
#Flying Bear Ghost 5

sudo visudo
klipper ALL=(ALL) NOPASSWD:ALL

sudo armbian-config

FlyingBearGhost5

sudo apt update -y
sudo apt upgrade -y




sudo apt-get install gpiod sendemail libnet-ssleay-perl libio-socket-ssl-perl -y

sudo usermod -a -G tty klipper
sudo usermod -a -G dialout klipper

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
5 05 * * * /home/klipper/backup_email.sh i

sudo chmod +x /home/klipper/backup_email.sh


cd ~
git clone https://github.com/th33xitus/kiauh.git
./kiauh/kiauh.sh

cd ~
git clone https://github.com/mainsail-crew/crowsnest.git
cd ~/crowsnest
sudo make install

cd ~
git clone https://github.com/nlef/moonraker-telegram-bot.git
cd moonraker-telegram-bot
./scripts/install.sh

cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
bash ~/moonraker-timelapse/install.sh


