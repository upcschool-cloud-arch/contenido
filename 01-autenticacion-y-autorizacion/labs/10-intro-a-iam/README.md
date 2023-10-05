# Introducción al IAM

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

## Credenciales en CloudAcademy

### Preparación

* Accede al entorno de laboratorio de Cloud Academy (*Modules* -> *Learners Lab*)
* Inicia el laboratorio (*Start Lab*, en la barra de botones superior)
* Utiliza la terminal web para mostrar el fichero de configuración de credenciales (generado automáticamente por el entorno)

```bash
cat ~/.aws/credentials
```

* Utiliza la terminal y la [CLI de AWS](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) para listar
las instancias existentes en la región de Irlanda (obtendrás un error, no tienes permisos)

```bash
aws ec2 describe-instances --region eu-west-1
```

* Realiza la misma operación pero esta vez sobre la región de Virginia (para la que sí tienes autorización):

```bash
aws ec2 describe-instances --region us-east-1
```

* Recupera la identidad que está asociada a las credenciales (AK/SK) que utilizas:

```bash
aws sts get-caller-identity
```

## Explorar IAM Permission Policies básicas

* Accede al entorno de laboratorio de Cloud Academy (*Modules* -> *Learners Lab*)
* Inicia el laboratorio (*Start Lab*, en la barra de botones superior)
* Abre la consola web para explorar AWS (pulsa sobre el enlace a la izquierda del círculo verde, sobre la terminal)
* Pulsa sobre la *omnibar* y busca el servicio *IAM*. Entra en él.
* En la barra de opciones de la izquierda selecciona *Policies*. Más adelante exploraremos los detalles de este servicio.
* Utiliza el buscador para encontrar las siguientes policies. Una vez localizada cada una de ellas, pulsa en su enlace y selecciona el botón etiquetado como `{}JSON` para revisar su contenido. Trata de entender a qué operaciones están haciendo referencia.

    - AdministratorAccess (si te pierdes, puedes viajar directamente [a los detalles de AdministratorAccess](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AdministratorAccess$jsonEditor)
    -  AmazonS3FullAccess 
    -  AmazonS3ReadOnlyAccess

## Credenciales en Cloudshell

### Preparación

* Acceder al servicio de [Cloudshell](https://aws.amazon.com/cloudshell/)

### Comprobar las credenciales actuales

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

### Ejecutar una petición a un servicio en AWS

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

### Actividades

Ahora que tienes el fichero `output.txt`, puedes utilizar el comando `grep` (o un editor de textos
como `nano`) para examinar su contenido y responder a las siguientes preguntas:

* *Boto* trata de encontrar credenciales válidas usando varios mecanismos. Revisando la salida
del comando puedes encontrar la lista de los mismos. ¿Podrías decir cuántos hay en total y en qué
consisten al menos tres de ellos?

<details>
<summary>Solución:</summary>

* env
* assume-role
* assume-role-with-web-identity
* sso
* shared-credentials-file
* custom-process
* config-file
* ec2-credentials-file
* boto-config
* container-role

</details>

* ¿Puedes localizar en la información de depuración el uso de una *Access Key*? ¿Dónde se encuentra?

<details>
<summary>Solución:</summary>
En el *header* `Authorization`, que en realidad transporta la información de autenticación.
</details>

* La *Secret Key* no aparece en dicha información de depuración debido a que no se envía
con la petición por motivos de seguridad. ¿Podrías explicar dónde se refleja su utilización
en el output del comando?

<details>
<summary>Solución:</summary>
Se utiliza en el cálculo de la firma de la petición, que aparece tras la cadena "Signature:"
y cuyo valor también se agrega al *header* `Authorization`.
</details>

* El *Session Token* solo se aplica para autentificar y autorizar credenciales temporal. Está
codificado usando base64, pero la mayor parte del mismo se encuentra encriptado. Utiliza el
comando [base64](https://dashdash.io/1/base64) para echar un vistazo a su contenido y reconocer
datos como el número de cuenta.

*nota: `tmux` puede reaccionar de forma divertida a algunas secuencias de caracteres. Si el prompt
queda inutilizado, utiliza `ctrl-b`+`c` para crear una ventana limpia.*

<details>
<summary>Solución:</summary>
<code>
  
curl -sH "Authorization: $AWS_CONTAINER_AUTHORIZATION_TOKEN" $AWS_CONTAINER_CREDENTIALS_FULL_URI \\
| jq .Token -r \\
| base64 -d > token.txt \\
echo

</code>
</details>

## Credenciales de Role en EC2 y Metadata

En esta actividad exploraremos cómo consiguen las aplicaciones ejecutadas en EC2 las credenciales
necesarias para trabajar con la infraestructura.

* Accede a la terminal de tu *workstation* usando la url correspondiente (`https://XXXXXXXX-workstation.aprender.cloud/vscode/proxy/7681`)

* Comprueba que tienes conectividad con el servicio de metadatos

```bash
curl http://169.254.169.254/latest/meta-data/
```

* Explora la construcción de URLs para obtener distintos datos sobre la máquina

```bash
curl http://169.254.169.254/latest/meta-data/; echo
curl http://169.254.169.254/latest/meta-data/local-hostname; echo
```

### Actividades

* Partiendo de `http://169.254.169.254/latest/meta-data/identity-credentials/` consigue recuperar el *Access Key*
junto al resto de datos de autenticación proporcionados por el *role* asociado a la máquina.

<details>
<summary>Solución:</summary>
<code>
curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance/ ; echo
</code>
</details>

## Metadata v2

La versión 2 del servicio de metadata se considera más segura, tras el incidente de [Capital One](https://securityboulevard.com/2020/06/the-capital-one-data-breach-a-year-later-a-look-at-what-went-wrong-and-practical-guidance-to-avoid-a-breach-of-your-own/). Se considera buena
práctica permitir solo este tipo de acceso al servicio de metadata.

Exploremos cómo puede utilizarse (es similar al uso que hacemos en *CloudShell*).

* Obtén el token de acceso y guárdalo en una variable

```bash
TOKEN=$(curl -s -X PUT \
   "http://169.254.169.254/latest/api/token" \
   -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
)
echo El token es $TOKEN.
```

* Utiliza el endpoint de metadata, pero esta vez proporcionando el token:

```bash
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
```
