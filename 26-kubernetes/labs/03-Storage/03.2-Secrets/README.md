# Shell Storage Examples

## Create the secret confg

```
kubectl apply -f secret.yaml
```

## Create the shell pod with the configmaps attached

```
kubectl apply -f shell.yaml
```

## Attach to the pod and review the configmaps

```
kubectl exec -ti shell-secret -- /bin/bash
```
