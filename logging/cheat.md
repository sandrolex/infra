# Logging ingra on k8 using elastic search fluentd and kibana

https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes

## test elastic search

```
kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging
```

```
curl 'http://localhost:9200/_cluster/state?pretty'
```

## kibana

```
kubectl rollout status deployment/kibana --namespace=kube-logging
```

```
kubectl port-forward kibana-6c9fb4b5b7-plbg2 5601:5601 --namespace=kube-logging
```


after fluentd install, create an index on `logstash-* `

and select field `@timestamp`

finaly, search for `kubernetes.pod_name:counter`






