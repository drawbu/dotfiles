
**Nginx** setup : [link](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-20-04)
Get the [CertBot HTTPS](https://certbot.eff.org/instructions?ws=nginx&os=ubuntufocal) certification.
In case `sudo ufw status` return `inactive` : 
```bash
sudo ufw enable
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'
sudo ufw allow 'OpenSSH'
```


# Add a server  : 

Simple HTML page :
```bash
sudo mkdir -p /var/www/DOMAIN_NAME/html
sudo chown -R $USER:$USER /var/www/DOMAIN_NAME/html
nanDOMAIN_NAME
sudo nano /var/www/DOMAIN_NAME/html/index.html
```

Or if a repo is ready :
```bash
sudo git clone REPOSITORY /var/www/DOMAIN_NAME
```

Add to Nginx : 
```bash
sudo nano /etc/nginx/sites-available/DOMAIN_NAME
```

```
server {
    listen 80;
    listen [::]:80;
	
	root /var/www/DOMAIN_NAME/html;
	index index.html index.htm index.nginx-debian.html;
	
	server_name DOMAIN_NAME;
	
	location / {
		try_files $uri $uri/ =404;
	}
}
```

Add to Nginx, verify, and restart 
```bash
sudo ln -s /etc/nginx/sites-available/DOMAIN_NAME /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

Add HTTPS : 
```bash
sudo certbot --nginx
```


[Serve Flask app with Gunicorn and Nginx](https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-22-04)
```shell
sudo nano /etc/systemd/system/DOMAIN_NAME.service
sudo systemctl stop DOMAIN_NAME
sudo systemctl daemon-reload
sudo systemctl start DOMAIN_NAME
sudo systemctl enable DOMAIN_NAME
sudo systemctl status DOMAIN_NAME
```


```
server {
    listen 80;
    server_name DOMAIN_NAME;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/clement/DOMAIN_NAME.sock;
    }
}
```
