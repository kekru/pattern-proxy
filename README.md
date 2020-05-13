# pattern-proxy

Choose a backend server, based on a regex pattern match of your subdomain.  
Simple env var configuration.

Inspired by [robszumski/k8s-service-proxy](https://github.com/robszumski/k8s-service-proxy)

## Configuration

Every proxy rule consist of three env variables:

+ `RULE_1_MODE`: &lt;mode&gt;
+ `RULE_1_PATTERN`: &lt;regex pattern&gt; (see [nginx regex names](http://nginx.org/en/docs/http/server_names.html#regex_names))
+ `RULE_1_TARGET`: &lt;target with usage of pattern variables&gt;

Example:  

```bash
RULE_1_MODE: 'HTTP'
RULE_1_PATTERN: '(?<service>.+).ab.127-0-0-1.nip.io'
RULE_1_TARGET: 'https://$service.ab.example.com'

RULE_2_MODE: 'HTTP'
RULE_2_PATTERN: '(?<service>.+).xy.127-0-0-1.nip.io'
RULE_2_TARGET: 'https://$service.xy.example.com'
```

This creates two rules.  
The following example requests will get the shown proxy actions:  

+ `http://hello.ab.127-0-0-1.nip.io` will proxy pass to  
  `https://hello.ab.example.com`
+ `http://world.xy.127-0-0-1.nip.io` will proxy pass to  
  `https://world.xy.example.com`

> Currently only mode HTTP is implemented

## Run with Docker

See [docker-compose.yml](docker-compose.yml) for a docker-compose configuration example.  

> Be sure to escape all `$` with a `$$` inside your env vars. Otherwise docker-compose will try to replace them

Or run without compose:  

```bash
  docker run -p 80:80 --name pattern-proxy \
    -e RULE_1_MODE=HTTP \
    -e RULE_1_PATTERN='(?<service>.+).ab.127-0-0-1.nip.io' \
    -e RULE_1_TARGET='https://$service.ab.example.com' \
    kekru/pattern-proxy:v0.1.0
```

## Endpoints

Proxies modes that should be supported:  

+ HTTP proxy pass
+ HTTPS proxy pass
+ TLS pass through (non terminating)
+ Forward TCP (terminating)

> Currently only HTTP proxy pass is implemented

For more information about TLS routing see [Nginx TLS SNI routing, based on subdomain pattern](https://gist.github.com/kekru/c09dbab5e78bf76402966b13fa72b9d2)
