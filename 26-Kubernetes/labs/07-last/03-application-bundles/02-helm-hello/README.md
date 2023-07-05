##

```
 helm repo add cloudecho https://cloudecho.github.io/charts/ && \
 helm repo update
```

```
helm pull cloudecho/hello
```


```
helm install my-hello cloudecho/hello -n hello --create-namespace --version=0.1.2 --set service.type=LoadBalancer --set service.port=80
```

```
helm install -n hello hello-local hello/
```