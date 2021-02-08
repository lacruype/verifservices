INFORMATION="\033[01;33m" #yellow
SUCCESS="\033[1;32m"      #green
ERROR="\033[1;31m"        #red
RESET="\033[0;0m"         #white

print_message()
{
	printf "$1%s ➜ $2$RESET\n"
}

if ! minikube status >/dev/null 2>&1
  then

    if ! minikube start --vm-driver=docker
    then
        print_message $ERROR "Minikube n'a pas demarre !"
        exit 1
    fi
    print_message $SUCCESS "Minikube a demarre."
  else
    print_message $SUCCESS "Minikube a deja demarre."
fi

SERVER_IP=$(minikube ip)
eval $(minikube docker-env)

minikube addons enable storage-provisioner

IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)


FIRST_IP="$(echo $IP | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.')105"
LAST_IP="$(echo $IP | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.')150"

echo $FIRST_IP
echo $LAST_IP

sed -i.bak "s/FIRST_IP/$FIRST_IP/g; s/LAST_IP/$LAST_IP/g" ./srcs/metallb/config.yaml
cp srcs/metallb/config.yaml ./srcs/metallb/tmp
cp srcs/metallb/config.yaml.bak ./srcs/metallb/config.yaml
mv srcs/metallb/tmp ./srcs/metallb/config.yaml.bak

# BUILD LES CONTAINERS DOCKER

	# NGINX
	docker build ./srcs/nginx/image/ -t nginx:local 

	# MYSQL
	docker build ./srcs/mysql/image/ -t mysql:local 

	# WORDPRESS
	sed -i.bak 's/http:\/\/IP/http:\/\/'"$SERVER_IP"'/g' ./srcs/wordpress/image/wp-config.php
	docker build ./srcs/wordpress/image/ -t wordpress:local 

	# PHPMYADMIN
	sed -i.bak 's/MYSQL_HOST/'""'/g' ./srcs/phpmyadmin/image/phpmyadmin.inc.php
	docker build ./srcs/phpmyadmin/image/ -t phpmyadmin:local

	# FTPS
	docker build ./srcs/ftps/image/ -t ftps:local

	# GRAFANA
	docker build ./srcs/grafana/image/ -t grafana:local

	# INFLUXDB
	docker build ./srcs/influxdb/image/ -t influxdb:local

# INSTALL METALLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.8.1/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metallb/config.yaml.bak

#APPLY YAML FILE
kubectl apply -f ./srcs/mysql/mysql.yaml
kubectl apply -f ./srcs/influxdb/influxdb.yaml

MYSQL_IP=$(kubectl get svc mysql-service | tail +2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tail +1)
INFLUX_IP=$(kubectl get svc influxdb-service | tail +2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tail +1)

sed -i.bak 's/MS_IP/'$MYSQL_IP'/' ./srcs/wordpress/wordpress.yaml
cp ./srcs/wordpress/wordpress.yaml ./srcs/wordpress/tmp
cp ./srcs/wordpress/wordpress.yaml.bak ./srcs/wordpress/wordpress.yaml
cp ./srcs/wordpress/tmp ./srcs/wordpress/wordpress.yaml.bak

kubectl apply -f ./srcs/wordpress/wordpress.yaml.bak
kubectl apply -f ./srcs/phpmyadmin/phpmyadmin.yaml
sleep 30

WORDPRESS_IP=$(kubectl get svc wordpress-service | tail +2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tail +2)
PHPMYADMIN_IP=$(kubectl get svc phpmyadmin-service | tail +2 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tail +2)
WORDPRESS_POD=$(kubectl get pod | grep -E "^wordpress" | cut -d' ' -f1)

print_message $SUCCESS $PHPMYADMIN_IP
print_message $SUCCESS $WORDPRESS_IP

sed -i.bak 's/WORDPRESS_IP/'$WORDPRESS_IP'/g; s/PHPMYADMIN_IP/'$PHPMYADMIN_IP'/' ./srcs/nginx/nginx.yaml
cp ./srcs/nginx/nginx.yaml.bak ./srcs/nginx/tmp
cp ./srcs/nginx/nginx.yaml ./srcs/nginx/nginx.yaml.bak
cp ./srcs/nginx/tmp ./srcs/nginx/nginx.yaml

kubectl apply -f ./srcs/nginx/nginx.yaml.bak
kubectl apply -f ./srcs/ftps/ftps.yaml
kubectl apply -f ./srcs/grafana/grafana.yaml

kubectl exec -it $WORDPRESS_POD -- sh /set_wordpress_ip.sh $WORDPRESS_IP

print_message $SUCCESS $MYSQL_IP
print_message $SUCCESS $INFLUX_IP

print_message $INFORMATION "Phpmyadmin username : "
print_message $SUCCESS "db_user"
print_message $INFORMATION "Phpmyadmin password : "
print_message $SUCCESS "db_password"

print_message $INFORMATION "Wordpress username : "
print_message $SUCCESS "admin"
print_message $INFORMATION "Wordpress password : "
print_message $SUCCESS "admin"

print_message $INFORMATION "FTPS username : "
print_message $SUCCESS "lacruype"
print_message $INFORMATION "FTPS password : "
print_message $SUCCESS "lacruype"

print_message $INFORMATION "Grafana username : "
print_message $SUCCESS "admin"
print_message $INFORMATION "Grafana password : "
print_message $SUCCESS "admin"

print_message $INFORMATION "Influx database :"
print_message $SUCCESS "telegraf"
print_message $INFORMATION "Influx username"
print_message $SUCCESS "influx_user"
print_message $INFORMATION "Influx password"
print_message $SUCCESS "influx_password"

print_message $INFORMATION "ssh connection :"
print_message $SUCCESS "ssh admin@SSH_IP"
print_message $INFORMATION "Password: "
print_message $SUCCESSS "admin"

minikube dashboard & 

echo $SERVER_IP
