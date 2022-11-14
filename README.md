# Jarkom-Modul-3-ITB07-2022     
### Laporan Resmi Pengerjaan Sesi Lab Jaringan Komputer     
        

#### Nama Anggota Kelompok :      
1. 5027201004 Alda Risma Harjian 
2. 5027201042 Ilham Muhammad Sakti 
3. 5027201067 Naufal Ramadhan 

## Soal 1 dan 2:
Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server, dan Ostania sebagai DHCP Relay.

![Topologi](./image/soal.jpeg)

#### JAWABAN
[ WISE ] -> DNS server
WISE sebagai DNS Server sehingga perlu melakukan install bind9
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
```

[ Berlint ] -> Proxy server

Berlint Sebagai Proxy server sehingga perlu melakukan install squid
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install libapache2-mod-php7.0 -y
apt-get install squid -y
```
[ Ostania ] -> DHCP Relay

Ostania sebagai DHCP Relay sehingga perlu melakukan install isc-dhcp-relay
```
apt-get update
apt-get install isc-dhcp-relay -y
```
[ Wetalis ] -> DHCP Server

```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y
```

Kami juga sudah membuat topologi

![Topologi](./image/topology.png)

Untuk konfigurasi setiap nodenya adalah sebagai berikut

[ Ostania ]
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.48.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.48.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.48.3.1
	netmask 255.255.255.0
```

[ WISE ]
```
auto eth0
iface eth0 inet static
	address 10.48.2.2
	netmask 255.255.255.0
	gateway 10.48.2.1
```

[ Berlint ]
```
auto eth0
iface eth0 inet static
	address 10.48.2.3
	netmask 255.255.255.0
	gateway 10.48.2.1
```

[ Westalis ]
```
auto eth0
iface eth0 inet static
	address 10.48.2.4
	netmask 255.255.255.0
	gateway 10.48.2.1
```

Untuk Setiap Client yaitu Eden, NewstonCatle, KemonoPark menggunakan konfigurasi sebagai berikut untuk penerapan DHCP

[ NewstonCastle dan KemonoPark ]
```
auto eth0
iface eth0 inet static
	address 10.48.3.4
	netmask 255.255.255.0
	gateway 10.48.3.1
```

Terkecuali untuk CLient Eden konfigurasinya seperti berikut

[ Eden ]
```
auto eth0
iface eth0 inet dhcp
hwaddress ether 3e:96:21:e3:73:e3
```

### SOAL 3
Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.15
#### JAWABAN
Konfigurasi DHCP Relay pada Ostania

[ Ostania ] -> DHCP Relay

Lakukan konfigurasi pada Ostania dengan melakukan edit file /etc/default/isc-dhcp-relay dengan konfigurasi berikut
```
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="10.45.2.4"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth3 eth2"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""

```

Konfigurasi DHCP Server pada Jipangu

[ Westalis ] -> DHCP Server

Membuat Westalis menjadi DHCP Server. Karena Westalis Terhubung dengan Ostania melalui eth0 sehingga lakukan konfigurasi pada file /etc/default/isc-dhcp-server sebagai berikut:

```
# Defaults for isc-dhcp-server initscript
# sourced by /etc/init.d/isc-dhcp-server
# installed at /etc/default/isc-dhcp-server by the maintainer scripts

#
# This is a POSIX shell fragment
#

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPD_CONF=/etc/dhcp/dhcpd.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPD_PID=/var/run/dhcpd.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACES="eth0"
```
Lakukan restart DHCP server dengan ```service isc-dhcp-server restart```
Setelah itu lakukan konfigurasi untuk rentang IP yang akan diberikan pada file  /etc/dhcp/dhcpd.conf dengan cara
```
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
```

### SOAL 4 
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85

### Jawaban Soal 4    
Lakukan konfigurasi untuk rentang IP yang akan diberikan pada file  `/etc/dhcp/dhcpd.conf` dengan cara menambahkan konfigurasi berikut ini 
```
subnet 10.48.3.0 netmask 255.255.255.0 {
    range  10.48.3.10 10.48.3.30;
    range  10.48.3.60 10.48.3.85;
    option routers 10.48.3.1;
    option broadcast-address 10.48.3.255;
    option domain-name-servers 10.48.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
```
Dengan begitu kita telah menentukan ip range  dengan menambahkan `range  10.48.3.30 10.48.3.50;`pada subnet interface switch 3 yang terhubung ke ostania pada eth3

### Soal 5
Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.

### Jawaban Soal 5
Untuk client mendapatkan DNS dari EniesLobby diperlukan konfigurasi pada file `/etc/dhcp/dhcpd.conf` dengan `option domain-name-servers 10.45.2.2;`

Supaya semua client dapat terhubung internet pada EniesLobby diberikan konfigurasi pada file `/etc/bind/named.conf.options` dengan
```
echo "
options {
        directory \"/var/cache/bind\";
        forwarders {
                8.8.8.8;
                8.8.8.4;
        };
        // dnssec-validation auto;
        allow-query { any; };
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
"
```
### Testing

### Soal 6
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit.

### Jawaban Soal 6
Pada subnet interface switch 1 dan 3 ditambahkan konfigurasi berikut pada file `/etc/dhcp/dhcpd.conf`
```
subnet 10.48.1.0 netmask 255.255.255.0 {
    ...
    default-lease-time 360; 
    max-lease-time 7200;
    ...
}
subnet 10.48.3.0 netmask 255.255.255.0 {
    ...
    default-lease-time 720;
    max-lease-time 7200;
    ...
}
```

### Soal 7
Loid dan Franky berencana menjadikan Eden sebagai server untuk pertukaran informasi dengan alamat IP yang tetap dengan IP [prefix IP].3.13

### Jawaban Soal 7
Menambahkan konfigurasi untuk fixed address pada `/etc/dhcp/dhcpd.conf`
```
host Eden {
    hardware ethernet 3e:96:21:e3:73:e3;
    fixed-address 10.48.3.13;
}
```
Setelah itu tidak lupa untuk mengganti konfigurasi pada file `/etc/network/interfaces` dengan
```
auto eth0
iface eth0 inet dhcp
hwaddress ether be:c0:ff:37:bb:09
```

### Soal 8
SSS, Garden, dan Eden digunakan sebagai client Proxy agar pertukaran informasi dapat terjamin keamanannya, juga untuk mencegah kebocoran data.

Pada Proxy Server di Berlint, Loid berencana untuk mengatur bagaimana Client dapat mengakses internet. Artinya setiap client harus menggunakan Berlint sebagai HTTP & HTTPS proxy. Adapun kriteria pengaturannya pertamanya adalah sebagai berikut:

```
Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)
```

### Jawaban Soal 8
[ Westalis ] -> DNS Server
Menambahkan konfigurasi domain `loid-work.com` dan `franky-work.com` pada WISE:

```
echo "
zone \"loid-work.com\" {
        type master;
        file \"/etc/bind/jarkom/loid-work.com\";
};
zone \"franky-work.com\" {
        type master;
        file \"/etc/bind/jarkom/franky-work.com\";
};
"> /etc/bind/named.conf.local
```

Kemudian, menambahkan domain seperti yang dibawah ini:
```
echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     franky-work.com. root.franky-work.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      franky-work.com.
@               IN      A       10.48.2.2     ; IP WISE
www             IN      CNAME   franky-work.com.
" > /etc/bind/jarkom/franky-work.com

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     loid-work.com. root.loid-work.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loid-work.com.
@       IN      A       10.48.2.2    ; IP WISE
www     IN      CNAME   loid-work.com.
" > /etc/bind/jarkom/loid-work.com
```

Lalu, memberikan konfigurasi pada masing-masing domain seperti berikut:

```
echo '
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName loid-work.com
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/loid-work.com.conf

echo '
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ServerName franky-work.com
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
' > /etc/apache2/sites-available/franky-work.com.conf
```

Selanjutnya, memberikan Konfigurasi web agar bisa dicek melalui client proxy dengan command `lynx`

[ Berlint ] -> Proxy Server
Mendeklarasikan waktu kerja dan diluar kerja, kemudian memberikan hak akses diluar jam kerja seperti berikut:

```
echo '
acl WORKTIME time MTWHF 08:00-17:00
acl WEEKEND time SA 00:00-23:59
' > /etc/squid/acl-time.conf
```

```
echo '
...
http_access allow !WORKTIME
http_access deny all
...
' > /etc/squid/squid.conf
```

Berikut merupakan dokumentasi hasil dari soal 8:
- Akses internet pada hari senin jam 10.00:<br>
![](image/soal8.1.png)

- Akses internet pada hari senin jam 20.00:<br>
![](image/soal8.2.png)

### Soal 9
Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)

### Jawaban Soal 9
Mendeklarasikan sejumlah domain kerja dan memberikan hak akses pada saat jam kerja

[ Berlint ] -> Proxy Server
```
echo '
loid-work.com
franky-work.com
' > /etc/squid/work-sites.acl
```

```
echo '
acl WORKSITE dstdomain "/etc/squid/work-sites.acl"
' > /etc/squid/acl-site.conf
```

```
echo '
...
http_access allow WORKSITE WORKTIME
...
' > /etc/squid/squid.conf
```

Untuk dokumentasi yaitu sebagai berikut:
- Melakukan akses pada loid-work.com dan franky-work.com ketika jam kerja:<br>
![](image/soal9.1.png)
- Melakukan akses pada loid-work.com dan franky-work.com diluar jam kerja:<br>
![](image/soal9.2.png) <br>
![](image/soal9.3.png)

### Soal 10
Saat akses internet dibuka, client dilarang untuk mengakses web tanpa HTTPS. (Contoh web HTTP: http://example.com)

### Jawaban Soal 10
[ Berlint ] -> Proxy Server

Port dari HTTPS yaitu 443, maka akan deklarasikan terlebih dahulu portnya kemudian akan melarang semua akses yang tidak melewati port 443 seperti berikut:

```
echo '
acl GOODPORT port 443
acl CONNECT method CONNECT
' > /etc/squid/acl-port.conf
```

```
echo '
...
http_access deny !GOODPORT
http_access deny CONNECT !GOODPORT
...
' > /etc/squid/squid.conf
```

Untuk dokumentasi yaitu sebagai berikut:
- Web HTTP:<br>
![](image/soal10.1.jpg)
- Web HTTPS:<br>
![](image/soal10.2.png)

### Soal 11
Agar menghemat penggunaan, akses internet dibatasi dengan kecepatan maksimum 128 Kbps pada setiap host (Kbps = kilobit per second; lakukan pengecekan pada tiap host, ketika 2 host akses internet pada saat bersamaan, keduanya mendapatkan speed maksimal yaitu 128 Kbps)

### Jawaban Soal 11
[ Berlint ] -> Proxy Server** <br>
Untuk membatasi kecepatan internet menjadi 128Kbps akan dilakukan dengan mengubah parameter internet menjadi 16000/16000 dengan sebagai berikut:

```
echo '
delay_pools 1
delay_class 1 1
delay_parameters 1 16000/16000
' > /etc/squid/acl-banwidth.conf
```

Untuk dokumentasi yaitu sebagai berikut:
<br>
![](image/soal11.jpg)

### Soal 12
Setelah diterapkan, ternyata peraturan nomor (4) mengganggu produktifitas saat hari kerja, dengan demikian pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur

### Jawaban Soal 12
[ Berlint ] -> Proxy Server
kita menambahkan konfigurasi bandwidth menjadi seperti berikut agar pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur:

```
echo '
delay_pools 1
delay_class 1 1
delay_access 1 allow WEEKEND
delay_parameters 1 16000/16000
' > /etc/squid/acl-banwidth.conf
```

Untuk dokumentasi yaitu sebagai berikut:
<br>
![](image/soal12.png)

## *Kendala*
