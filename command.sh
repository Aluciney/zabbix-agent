sudo usermod -aG docker zabbix
chmod 666 /var/run/docker.sock
chmod +x /home/zabbix-agent/docker-restart.sh