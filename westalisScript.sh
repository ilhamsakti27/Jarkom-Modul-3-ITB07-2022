# nomor 1
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y

# nomor 3
echo "
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. \"eth0 eth1\".
INTERFACES=\"eth0\"
" > /etc/default/isc-dhcp-server

echo "
subnet 10.48.2.0 netmask 255.255.255.0 {
}
subnet 10.48.1.0 netmask 255.255.255.0 {
    range  10.48.1.50 10.48.1.88;
    range  10.48.1.120 10.48.1.155;
    option routers 10.48.1.1;
    option broadcast-address 10.48.1.255;
    option domain-name-servers 10.48.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}

subnet 10.48.3.0 netmask 255.255.255.0 {
    range  10.48.3.10 10.48.3.30;
    range  10.48.3.60 10.48.3.85;
    option routers 10.48.3.1;
    option broadcast-address 10.48.3.255;
    option domain-name-servers 10.48.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}

host Eden {
    hardware ethernet 3e:96:21:e3:73:e3;
    fixed-address 10.48.3.13;
}
" >  /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart
service isc-dhcp-server restart