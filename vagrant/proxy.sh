#!/bin/bash 

apt-get update -y
apt-get install nginx -y 
unlink /etc/nginx/sites-enabled/default

cat > /etc/nginx/sites-available/reverse-proxy.conf <<EOF
server {
        listen 80;
        listen [::]:80;

        access_log /var/log/nginx/reverse-access.log;
        error_log /var/log/nginx/reverse-error.log;

        location / {
                    proxy_pass http://192.168.1.194:31260;
  	}
}
EOF


ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf

systemctl enable nginx
systemctl restart nginx
