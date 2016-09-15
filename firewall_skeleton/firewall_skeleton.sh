#!/bin/bash
#
#  Author: Spacecow
#  Date: 29/06/2016
#  Description:
#  Skeleton Firewall Script.


#############################
#  CONFIGURATION
#############################

# Find iptables binary
IPTABLES=$(which iptables)

# Define your interface address
ADDRESS=127.0.0.1


#############################
#  SETUP
#############################

# Clear all rules
${IPTABLES} -F

# Don't forward traffic
${IPTABLES} -P FORWARD -j DROP

# Allow outgoing traffic
${IPTABLES} -P OUTPUT -j ACCEPT

# Allow established traffic
${IPTABLES} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow localhost traffic
${IPTABLES} -A INPUT -i lo -j ACCEPT


#############################
#  MANAGEMENT RULES
#############################

# Allow SSH server
${IPTABLES} -A INPUT -p tcp --dport 22 -j LOG --log-level 7 --log-prefix "Accept 22 SSH"
${IPTABLES} -A INPUT -p tcp -d ${ADDRESS} --dport 22 -j ACCEPT


#############################
#  ACCESS RULES
#############################

# Allow HTTP server
${IPTABLES} -A INPUT -p tcp --dport 80 -j LOG --log-level 7 --log-prefix "Accept 80 HTTP"
${IPTABLES} -A INPUT -p tcp -d ${ADDRESS} --dport 80 -j ACCEPT


#############################
#  DEFAULT DENY
#############################

${IPTABLES} -A INPUT -d ${ADDRESS} -j LOG --log-level 7 --log-prefix "Default Deny"
${IPTABLES} -A INPUT -j DROP
