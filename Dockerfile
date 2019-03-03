FROM nginx:1.15-alpine
ADD nginx.conf /etc/nginx/nginx.conf
ADD script/ /data/script
ADD templates/ /data/templates
RUN chmod +x /data/script/*.sh 

ENV RULE_1_MODE=TLSTERM \
    RULE_1_PATTERN='~^(?<service>.+)-(?<deployment>.+)-(?<namespace>.+).app.192.168.0.150.nip.io$' \  
    RULE_1_TARGET='$service-$deployment-public.$namespace.svc.cluster.local.192.168.0.150.nip.io:9876'
ENV RULE_2_MODE=HTTP \
    RULE_2_PATTERN=~^(?<service>.+).example.com \  
    RULE_2_TARGET=whiledo.de:80

ENV BASE_URL=app.192.168.0.150.nip.io \
    DNS_RESOLVER=kube-dns.kube-system.svc.cluster.local

ADD tmp/certs /certs


ENTRYPOINT ["/data/script/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
