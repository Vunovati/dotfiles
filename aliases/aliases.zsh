alias asadmin="/home/evlaada/sailfin/bin/asadmin"
alias hosts="cat /etc/hosts"
alias tcpdumpget="sudo tcpdump -s 0 -A 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'"
alias tcpdumppost="sudo tcpdump -s 0 -A 'tcp dst port 80 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354)'"
