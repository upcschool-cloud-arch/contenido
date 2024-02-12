### MySQL Deployment

```
kubectl apply -f mysql-deployment.yaml
```

### Check for issues

```
kubectl describe pod -l app=mysql
```

### Deploy secret

```
kubectl apply -f mysql-credentials-secret.yaml
```

### Deploy a wordpress with a PVC

```
kubectl apply -f wordpress-deployment.yaml
```

### Get the wordpress load balancer

```
kubectl get svc wordpress
```

### Delete the mysql pod

```
kubectl delete pod -l app=mysql
```

### Check the app

(All MySQL backed data is gone)

### Cleanup

```
kubectl delete -f .
```
