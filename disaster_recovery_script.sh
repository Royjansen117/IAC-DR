#!/bin/bash
printf "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
printf "@@@          Welkom bij Disaster recovery           @@@"
printf "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
printf "\n"
printf "\n"

echo "Welkom bij het disaster recovery geautomatiseerde script."
echo "Dit script neemt een deel van de benodigde recovery taken over voor een versnelde terugkeer naar productie."
echo "Een deel van de taken moet echter nog handmatig worden uitgevoerd. Hiervoor is het Disaster Recovery Document (DRD) benodigd"
echo
read -p "Druk op enter als u dit document bij de hand heeft en het script met de geautomatiseerde taken wilt starten:"  

# Eerst wordt de mappenstructuur opnieuw aangemaakt en de gedownloade recovery bestanden uitgepakt.

echo "De mappenstructuur wordt opnieuw gemaakt: /home/student/IAC/ /klanten & /productie/files"
mkdir -p /home/student/IAC/productie/files
mkdir -p /home/student/IAC/klanten
# En de rechten toegepast op het student account.
sudo chown -R student:student /home/student/IAC
echo "De bestanden worden uitgepakt naar: /home/student/IAC/productie/files"
# De bestanden worden uitgepakt in deze opnieuw gemaakte mappen.
unzip -d /home/student/IAC/productie/ iac_ssp.zip
unzip -d /home/student/IAC/productie/files/ iac_config.zip


# Dan wordt de extra schijf voor de VM's toegevoegd en gemount.

echo "Extra opslagruimte voor de VM's wordt geformateerd en gemount"
sudo parted /dev/sdb mklabel gpt
sudo parted -a opt /dev/sdb mkpart primary ext4 0% 100%
sudo mkfs.ext4 -L VMlib /dev/sdb1
sudo mkdir -p /mnt/VMlib
sudo mount -o defaults /dev/sdb1 /mnt/VMlib
sudo echo "/dev/sdb1 /mnt/VMlib ext4 defaults 0 2" >> /etc/fstab
sudo chown -R student:student /mnt/VMlib

# Een ssh keypair wordt aangemaakt voor de veilige verbindingen tussen de host en de guest VM's
echo "ssh-key genereren.."
echo | ssh-keygen -t rsa
echo
echo
echo "Einde disaster recovery. De overige taken moeten handmatig worden uitgevoerd. Keer hiervoor weer terug naar het disaster recovery document."
echo
printf "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo

