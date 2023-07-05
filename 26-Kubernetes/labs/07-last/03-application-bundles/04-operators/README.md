
### Install Grafana

```
helm upgrade -i grafana-operator oci://ghcr.io/grafana-operator/helm-charts/grafana-operator --namespace monitoring --version v5.0.0
```

### Setup Grafana

Now that Prometheus and Grafana are up and running, you can access Grafana:

```
kubectl apply -f 00-monitoring --namespace monitoring
```

Wait for the load balancer to be provisioned:

```
kubectl get svc -n monitoring grafana-service
```

```
echo "http://$(kubectl get svc -n monitoring grafana-service \
    -o jsonpath="{.status.loadBalancer.ingress[*]['ip', 'hostname']}")"
```

To login, username: `admin`, password: `admin`.
