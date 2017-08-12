#!/bin/sh
# launcher script
wait(){
docker run -e PORTS=$1 --link $2 n3llyb0y/wait
    echo "$2 OK"
}
registrator(){
echo 'launch registrator....'
docker run -d --name=registrator --net=host --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator:latest -internal consul://localhost:8500
}
consul(){
echo 'launch consul....'
#docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp --net=host --name=consul -e VIRTUAL_HOST=consul.fpl.labs.com -e VIRTUAL_PORT=8500 progrium/consul -server -bootstrap
docker run -d --name=consul -h consul.fpl.labs.com -e "SERVICE_8400_TAGS=RPC" -e "SERVICE_8400_NAME=consul" -e "SERVICE_8302_NAME=consul" -e "SERVICE_8301_NAME=consul" -e "SERVICE_8300_NAME=consul" -e "SERVICE_8500_NAME=consul" -e "SERVICE_53_NAME=consul" -e "SERVICE_8500_TAGS=HTTP" -e "SERVICE_53_TAGS=DNS" -p 8500:8500 -p 8600:53/udp progrium/consul -server -bootstrap
}

wildfly(){
echo 'launch consul....'
#docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp --net=host --name=consul -e VIRTUAL_HOST=consul.fpl.labs.com -e VIRTUAL_PORT=8500 progrium/consul -server -bootstrap
docker run -d -p 8080:8080 -e "SERVICE_8080_NAME=wildfly" -e "SERVICE_8080_TAGS=HTTP" -p 9990:9990 "SERVICE_9990_NAME=wildflyadmin" -e "SERVICE_9990_TAGS=HTTP"  --name widldfly jboss/wildfly /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
}
mysql() {
echo 'launch mysql....'
docker run -d -p 3306:3306 -v $(pwd)/storage/sql/data:/var/lib/mysql --name mysql -h mysql -e "SERVICE_3306_NAME=mysql"  -e "SERVICE_3306_TAGS=mysql"  -e MYSQL_ROOT_PASSWORD=root mysql:5.7.12
}

haproxy(){
echo 'launch ha proxy'
docker build -t jb/haproxy ha-proxy/
docker run -d --name=haproxy -p 80:80 -p 9000:9000 jb/haproxy

}

up() {
    consul
    registrator
    haproxy
    wait 80 haproxy
    wildfly


}
stop() {
echo "stop container : "
    docker rm -f registrator
    docker rm -f consul
    docker rm -f haproxy
    docker rm -f wildfly
}

$*
