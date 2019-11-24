#/bin/sh
apt-get -y remove google-chrome-stable
rm /etc/apt/sources.list.d/google.list
apt-get -y remove oracle-java8-installer
