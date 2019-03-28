FROM nginx:1.13.3
RUN apt-get update -qq && apt-get -y install apache2-utils
RUN rm -f /etc/nginx/conf.d/*
COPY docker/config/nginx/app.conf /etc/nginx/conf.d/app.conf
CMD [ "nginx", "-g", "daemon off;" ]