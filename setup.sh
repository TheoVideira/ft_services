#!/bin/sh

# Start docker
minikube start --driver=docker
# Enable dashboard
minikube addons enable dashboard

# Installing Metallb
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
kubectl get secret -n metallb-system memberlist
if [ $? != 0 ]
then
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi

# Get external IP
export EXTERNAL_IP=`minikube ip`

# Apply external IP to template files
envsubst '$EXTERNAL_IP' < srcs/yaml/configmaps/metallb_configmap.yaml           > srcs/yaml/metallb_configmap.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/configmaps/wp_db_configmap.yaml             > srcs/yaml/wp_db_configmap.yaml

envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/mysql.yaml         > srcs/yaml/mysql.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/wordpress.yaml     > srcs/yaml/wordpress.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/phpmyadmin.yaml    > srcs/yaml/phpmyadmin.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/nginx.yaml         > srcs/yaml/nginx.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/ftps.yaml          > srcs/yaml/ftps.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/grafana.yaml       > srcs/yaml/grafana.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/services_and_deployments/influxdb.yaml      > srcs/yaml/influxdb.yaml

# Apply secrets
kubectl apply -f srcs/yaml/secrets

# Apply configmaps
kubectl apply -f srcs/yaml/metallb_configmap.yaml
kubectl apply -f srcs/yaml/wp_db_configmap.yaml

# Ensure all shell script copied are executable
chmod +x srcs/*/srcs/*.sh

# Building images
eval $(minikube docker-env)
docker build -t my_mysql        srcs/mysql
docker build -t my_wordpress    srcs/wordpress
docker build -t my_phpmyadmin   srcs/phpmyadmin
docker build -t my_nginx        srcs/nginx
docker build -t my_ftps         srcs/ftps
docker build -t my_grafana      srcs/grafana
docker build -t my_influxdb     srcs/influxdb

# Apply deployments and services
kubectl apply -f srcs/yaml/mysql.yaml
kubectl apply -f srcs/yaml/wordpress.yaml
kubectl apply -f srcs/yaml/phpmyadmin.yaml
kubectl apply -f srcs/yaml/nginx.yaml
kubectl apply -f srcs/yaml/ftps.yaml
kubectl apply -f srcs/yaml/grafana.yaml
kubectl apply -f srcs/yaml/influxdb.yaml

# Start dashboard
minikube dashboard &