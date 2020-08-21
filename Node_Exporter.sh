#!/bin/bash
yum install wget -y
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
mkdir -p /var/lib/prometheus/node_exporter
mv node_exporter-0.18.1.linux-amd64/* /var/lib/prometheus/node_exporter
cd
chown -R prometheus:prometheus /var/lib/prometheus/node_exporter/
echo "
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/var/lib/prometheus/node_exporter/node_exporter

[Install]
WantedBy=default.target
" > /usr/lib/systemd/system/node_exporter.service
systemctl enable --now node_exporter.service
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --reload
echo "
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
" >> /etc/prometheus/prometheus.yml
systemctl restart prometheus.service
