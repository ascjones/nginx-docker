# rewrite http to https
server {
      listen 80;
      server_name git.ascjones.com;
      rewrite ^(.*) https://git.ascjones.com$1 permanent;
}

server {
    server_name git.ascjones.com;
    listen 443;
    ssl on;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    ssl_session_timeout 5m;

    ssl_protocols SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv3:+EXP;
    ssl_prefer_server_ciphers on;

    location / {
        add_header           Front-End-Https    on;
        add_header  Cache-Control "public, must-revalidate";
        add_header Strict-Transport-Security "max-age=2592000; includeSubdomains";
        proxy_pass http://docker_gogs_1:3000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
