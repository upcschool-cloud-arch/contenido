# CloudShell e IAM

## Conceptos

* Credenciales de usuario
* AWS Command Line Interface (CLI)
* IAM Policies
* CloudShell
* Temporal credentials
* Security Token Service (STS)
* Containers credentials service
* Access key
* Secret key
* Session token
* Boto
* AWS CLI
* Servicio de metadata


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

## Ejecutar una petición a un servicio en AWS

* Invoca el servicio `STS` para obtener información sobre la identidad actual

```bash
aws sts get-caller-identity
```

* Reproduce la misma llamada, pero obteniendo información de depuración

```bash
aws sts get-caller-identity --debug
```

* Envía la salida detallada del comando al fichero `output.txt` para su posterior análisis

```bash
aws sts get-caller-identity --debug 2> output.txt
```

* Localiza en el fichero `output.txt` las credenciales mostradas anteriormente.
