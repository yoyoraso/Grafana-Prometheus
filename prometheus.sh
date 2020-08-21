#!/bin/bash
yum install wget -y
useradd --no-create-home -s /bin/false prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.13.1/prometheus-2.13.1.linux-amd64.tar.gz
tar xvzf prometheus-2.13.1.linux-amd64.tar.gz
mv prometheus-2.13.1.linux-amd64/* /var/lib/prometheus/
chown -R prometheus:prometheus /var/lib/prometheus
cd
mv /var/lib/prometheus/prometheus.yml /etc/prometheus/
ln -s /var/lib/prometheus/prometheus /usr/local/bin/prometheus
echo "
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/var/lib/prometheus/consoles \
--web.console.libraries=/var/lib/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
" >  /usr/lib/systemd/system/prometheus.service
systemctl enable --now prometheus.service
firewall-cmd --permanent --add-port=9090/tcp
firewall-cmd --reload

