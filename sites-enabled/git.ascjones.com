server {
    listen 80;
    server_name git.ascjones.com;

    location / {
        proxy_pass http://localhost:3000;
    }
}
