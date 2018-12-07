# use jwilder's ngin-proxy image
FROM jwilder/nginx-proxy

# change the template of the config and set permissions
COPY nginx.tmpl /app/nginx.tmpl
RUN chmod 0755 /app/nginx.tmpl

# copy static page to serve links and set permissions
COPY ./LandingPage/ /etc/nginx/html/
