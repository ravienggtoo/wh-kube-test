# wh-kube-test
- I have created EKS cluster and EKS Managed Node group using terraform.
- I created a custom nginx docker image and pushing to my dockerhub registry.
- Once EKS Cluster is created, I am deploying metrics-server, creating secrets to pull docker image from registry, kubernetes components etc.

# Requirements
- We need following tool sets for executing code in this repository 
```
awscli
terraform
docker
kubectl 
```

# EKS - terraform
- Configure AWS credentials.
- Kindly change the variable vpc_subnet_ids according to your custom aws account vpc subnet ids.
- Execute following commands to create eks cluster
```
terraform init
terraform plan
terraform apply
```
- Once EKS cluster is created, KUBECONFIG file will created in the current directory.

# Build docker image
- Creating custom nginx docker image and pushing it to my dockerhub repo
- Build docker image
```
docker build --platform linux/amd64 -t ravienggtoo/wh-nginx:1 . 
```
- Push docker image
```
docker push ravienggtoo/wh-nginx:1
```

# Apply Kubernetes Resources
- Export KUBECONFIG file
```
export KUBECONFIG=./KUBECONFIG
```  

- Installing metrics server component to gather metrics of Pods required by HPA.
```
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

- Creating secrets to pull docker image from registry
```
kubectl create secret docker-registry wh-test-docker-registry --docker-server=dockerhub.io --docker-username=<username> --docker-password=<password>
```

- Creating Following kubernetes components
*   Kubernetes service with NodePort type.
*  Kubernetes service account along with imagePullSecrets created above.
* Kubernetes Secret API KEY.
*  Kubernetes Deployment with rolling update to have maxUnavaibale as 1 Pod, Secret API KEY mounted and available as ENV variable, Config to run as Non-Root user.
*   Horizontal Pod Scaling configured if CPU or Memory utilization is higher.
*  Pod Disruption Budget to make sure minimum 2 pods are available in case of any disruption occurence.
```
kubectl apply -f nginx-app.yml
```  
  
