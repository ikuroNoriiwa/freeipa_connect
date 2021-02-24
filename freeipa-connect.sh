#!/bin/bash 


hostname=`hostname | awk '{print tolower($0)}'`
domaine="chicago.project.space"
realm="CHICAGO.PROJECT.SPACE"
ipa_server_ip="10.20.12.10"
ipa_server_name="ipa"
ipa_admin_user="admin"

sudo hostnamectl set-hostname $hostname.$domaine
sudo apt install freeipa-client -y
sudo -- sh -c  "echo \"$ipa_server_ip   $ipa_server_name.$domaine       $ipa_server_name\" >> /etc/hosts"
sudo ipa-client-install --hostname=`hostname -f` --mkhomedir --server=$ipa_server_name.$domaine --domain $domaine --realm $realm

sudo echo "Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
required pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /usr/share/pam-configs/mkhomedir

sudo pam-auth-update

sudo kinit $ipa_admin_user
sudo klist

sudo ipa config-mod --defaultshell=/bin/bash



