```shell
terraform init -upgrade
```

```shell
terraform apply -target=kubernetes_namespace.cert_manager -target=helm_release.cert_manager -auto-approve
```

```shell
terraform plan
```

```shell
terraform apply -auto-approve
```

```shell
terraform destroy -auto-approve
```

```shell
terraform graph > graph.dot
```

```shell
dot -Tpng graph.dot -o graph.png
```
