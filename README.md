# pattern-proxy
choose backend server, based on a pattern match of your subdomain

Inspired by [robszumski/k8s-service-proxy](https://github.com/robszumski/k8s-service-proxy)


if nip.io does not work:  
`curl -k -I --resolve nginx-pr123-default.app.192.168.0.150.nip.io:443:192.168.0.150 https://nginx-pr123-default.app.192.168.0.150.nip.io/`  