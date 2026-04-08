#!/bin/bash

yum update -y
yum install -y iptables-services iproute

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

modprobe geneve

ip link add geneve0 type geneve id 100 remote 0.0.0.0 dstport 6081
ip link set geneve0 up

iptables -F
iptables -t nat -F

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A INPUT -p udp --dport 6081 -j ACCEPT

service iptables save
systemctl enable iptables
systemctl start iptables