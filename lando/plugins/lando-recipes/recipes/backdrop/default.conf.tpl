server {
  listen 80 default_server;
  listen 443 ssl;

  server_name localhost;

  ssl_certificate           /certs/cert.crt;
  ssl_certificate_key       /certs/cert.key;
  ssl_verify_client         off;

  ssl_session_cache    shared:SSL:1m;
  ssl_session_timeout  5m;

  ssl_ciphers  HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers  on;

  root "{{LANDO_WEBROOT}}";

  index index.html index.htm index.php;

  port_in_redirect off;
  client_max_body_size 100M;

  location / {
    error_page 404 = @backdrop;
  }

  location @backdrop {
    rewrite ^(.*)$ /index.php?q=$1 last;
  }

  location ~ \.php$ {
    fastcgi_pass fpm:9000;
    include fastcgi_params;
    fastcgi_param HTTP_PROXY "";
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_path_info;
    fastcgi_param QUERY_STRING $query_string;
  }

}
