Create a file for each chain under /etc/rsyslog.d/00-my_iptables.conf containing:

:msg,contains,"[<chain name>] " -/var/log/<chain name>.log
& stop
