server {
    listen 80;
    server_name ascjones.com;
    location / {
        root /var/www/blog;
    }
}
