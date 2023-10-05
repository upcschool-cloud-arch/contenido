# El uso de credenciales por el CLI

El AWS CLI está escrito utilizando la librería de Python [Boto](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html), que utiliza una serie de mecanismos para tratar de obtener las credenciales
necesarias para invocar el API. Vamos a explorarlos.

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

## Actividades

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
