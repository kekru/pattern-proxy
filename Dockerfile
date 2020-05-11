FROM nginx:1.18-alpine
ADD nginx.conf /etc/nginx/nginx.conf
ADD script/ /data/script
ADD templates/ /data/templates
RUN chmod +x /data/script/*.sh 

ENV DNS_RESOLVER=1.1.1.1

ENTRYPOINT ["/data/script/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
