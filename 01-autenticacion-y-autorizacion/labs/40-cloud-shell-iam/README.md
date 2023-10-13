# CloudShell e IAM

## Preparación

* Acceder al servicio de [Cloudshell](https://aws.amazon.com/cloudshell/)

## Comprobar las credenciales actuales

* Mostrar el *endpoint* de sts

```bash
echo $AWS_CONTAINER_CREDENTIALS_FULL_URI
```

* Mostrar el *token de autenticación* (utilizado para invocar el *container authorization service*)

```bash
echo $AWS_CONTAINER_AUTHORIZATION_TOKEN
```

* Recuperar las credenciales del *container authorization service*

```bash
curl -H "Authorization: $AWS_CONTAINER_AUTHORIZATION_TOKEN" $AWS_CONTAINER_CREDENTIALS_FULL_URI
```

