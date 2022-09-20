#!/bin/bash

#Using script in /root as the rcs-node-config is public and the registration script has a private key
/root/reg-with-sate.sh

#Will need epel for updates. Following advice from https://www.redhat.com/en/blog/whats-epel-and-how-do-i-use-it
ARCH=$( /bin/arch )
subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

#Install dnf-automatic. https://access.redhat.com/solutions/2823901
dnf -y install dnf-automatic
##By default updates are only downloaded. Setting to install them as well.
sed -i "s/apply_updates = no/apply_updates = yes/g" /etc/dnf/automatic.conf

#Pull automatic update script from github
cd /opt/imperial
git clone https://github.com/ImperialCollegeLondon/rcs-dnf-automatic.git

#Using different timers so updates can be tested before being applied to prod
if [[ "$(hostname -s)" == "login-dev" || "$(hostname -s)" == "cx3-12-29" ]] ; then
    cp /opt/imperial/rcs-dnf-automatic/rcs-dnf-automatic.dev-timer /etc/systemd/system/rcs-dnf-automatic.timer
else
    cp /opt/imperial/rcs-dnf-automatic/rcs-dnf-automatic.prod-timer /etc/systemd/system/rcs-dnf-automatic.timer
fi

#dnf-automatic wrapper to kick users off and handle GPFS
cp /opt/imperial/rcs-dnf-automatic/rcs-dnf-automatic.service /etc/systemd/system/
cp /opt/imperial/rcs-dnf-automatic/rcs-dnf-automatic /usr/bin/

#Run updates once without the user timer
/usr/bin/rcs-dnf-automatic --now

#Start timer for future updates
systemctl enable --now rcs-dnf-automatic.timer

