#!/bin/bash
yum install wget -y
echo "
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
" > /etc/yum.repos.d/grafana.repo
yum makecache fast -y
yum install -y grafana
systemctl enable --now grafana-server.service
firewall-cmd --permanent --add-port=3000/tcp
firewall-cmd --reload

echo "User_name:admin"
echo "Password:admin"
