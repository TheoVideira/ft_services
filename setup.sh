# - Instruction pour moi même
# 1 Créer une image wordpress                               - OK
# 2 Créer une image mysql                                   - OK
# 3 Connecter les deux container via minikube et metallb    - TODO
# 4 PHP_MYADMIN                                             - TODO


# - Mise en place
minikube start --driver=docker
minikube addons enable dashboard


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


kubectl apply -f srcs/yaml/secrets


LAST_OCTET=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 4`
OTHER_PART=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 1-3`

#export EXTERNAL_IP=${OTHER_PART}.$(($LAST_OCTET+1))
export EXTERNAL_IP=`minikube ip`


envsubst '$EXTERNAL_IP' < srcs/yaml/templates/metallb_configmap.yaml    > srcs/yaml/metallb_configmap.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/templates/wordpress.yaml            > srcs/yaml/wordpress.yaml
envsubst '$EXTERNAL_IP' < srcs/yaml/templates/mysql.yaml                > srcs/yaml/mysql.yaml


kubectl apply -f srcs/yaml/metallb_configmap.yaml

chmod +x srcs/mysql/srcs/*.sh 

eval $(minikube docker-env)
docker build -t my_mysql        srcs/mysql
docker build -t my_wordpress    srcs/wordpress

kubectl apply -f srcs/yaml/mysql.yaml
kubectl apply -f srcs/yaml/wordpress.yaml


minikube dashboard &