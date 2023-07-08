##

```
 helm repo add cloudecho https://cloudecho.github.io/charts/ && \
 helm repo update
```

### Local install

```
helm pull cloudecho/hello --untar
```

```
helm install -n hello hello-local hello/
```

### From the repo

```
helm install my-hello cloudecho/hello -n hello --create-namespace --version=0.1.2 --set service.type=LoadBalancer --set service.port=80
```