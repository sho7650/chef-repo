default['nginx']['cache_dir']               = "/var/cache/nginx"

default['nginx']['forward']['listen_port']  = "172.16.254.254:8080"
default['nginx']['forward']['server_name']  = "172.16.254.254"
default['nginx']['forward']['resolver_ip']  = "192.168.0.102"

default['nginx']['reverse']['listen_port']  = "192.168.0.122:80"
default['nginx']['reverse']['server_name']  = "izumi.oshiire.to"
default['nginx']['reverse']['proxy_url']    = "http://172.16.254.101/"
