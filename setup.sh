# - Instruction pour moi même
# 1 Créer une image wordpress                               - OK
# 2 Créer une image mysql                                   - OK
# 3 Connecter les deux container via minikube et metallb    - TODO
    # Fichier .yaml
    # mysql.yaml
    # wordpress.yaml


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

LAST_OCTET=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 4`
OTHER_PART=`docker network inspect bridge --format='{{(index .IPAM.Config 0).Gateway}}' | cut -d . -f 1-3`

export EXTERNAL_IP=${OTHER_PART}.$(($LAST_OCTET+1))

envsubst '$EXTERNAL_IP' < srcs/yaml/templates/metallb_configmap.yaml > srcs/yaml/metallb_configmap.yaml
kubectl apply -f ./srcs/yaml/metallb_configmap.yaml

