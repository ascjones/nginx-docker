FROM dockerfile/nginx

ADD sites-enabled/ /etc/nginx/sites-enabled
ADD ssl/ /etc/nginx/ssl

