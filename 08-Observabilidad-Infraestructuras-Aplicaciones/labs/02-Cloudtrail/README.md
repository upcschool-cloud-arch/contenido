# Lab 8.2 - CloudTrail

## Objetivos
Es esta práctica, aprenderemos a monitorizar la utilización de la API de AWS, utilizando CloudTrail. 
Aprenderemos los principios básicos de CloudTrail y herramientas asociadas para lanzar consultas contra el servicio.

## Storytelling
En el equipo de la empresa se ha detectado un gran número de bajas por depresión. A raiz de este hecho, el departamento de RRHH ha pedido instalar una pantalla en la oficina que proyecte imágenes aleatorias de gatitos 24/7. Según un estudio de la Universidad de Leeds, ver videos e imágenes de animales puede ayudar a reducir el estrés hasta un 50% (https://biologicalsciences.leeds.ac.uk/school-biomedical-sciences/news/article/273/what-are-the-health-benefits-of-watching-cute-animals).
Para este caso de uso, se ha manifestado la necesidad de desplegar una API que nos proporcione imágenes de gatitos aleatorias. 

Nuestro compañero Juan ha encontrado una API en GitHub que parece que cumple con el caso de uso (https://github.com/TheMatrix97/suspicious-api-js). La despliegan y pasado unos meses, descubren que el coste operativo de AWS se ha duplicado. ¿De quién ha sido la culpa? ¿Está relacionado con la API que desplegó Juan? No lo sabemos. ¿Cómo podemos prepararnos para estas situaciones y evitar que se vuelvan a repetir? En esta práctica aprenderemos como utilizar CloudTrail para poder monitorizar el uso que hacen usuarios y aplicaciones de nuestro entorno de AWS.

## Lab

### Configuración CloudTrail

1- Primero, crearemos una traza de CloudTrail en nuestra cuenta, para almacenar y posteriormente consultar la actividad en nuestra cuenta de AWS

1.1 - Buscamos el servicio de CloudTrail en el buscador integrado de AWS

![Search Cloudtrail](./img/select-cloudtrail.PNG)

1.2 - Abrimos el menú de la izquierda y accedemos al panel de CloudTrail

![Panel Cloudtrail](./img/cloudtrail_panel.PNG)

1.3 - En el panel, podremos observar el historial de eventos recientes registrados por CloudTrail, estos no se guardan y se pierden pasados 90 dias. Si queremos almacenar los eventos y poder acceder a estos pasado el límite de días, debemos crear un registro o `trail`. Haremos click a la opción `Crear un registro de seguimiento` para crear uno.

![Panel Cloudtrail 2](./img/cloudtrail_panel_2.PNG)


1.4 - Indicamos el nombre de la `traza` a crear, desactivando el cifrado SSE-KMS (para este laboratorio no será necesario).

![Crear traza 1](./img/crear_traza_1.PNG)

1.5 - Seguidamente, indicaremos que solo queremos almacenar los eventos de administración, de tipo lectura y escritura. Hacemos click a siguiente, revisamos los datos y finalmente crearemos la `traza`

![Crear traza 2](./img/crear_traza_2.PNG)

1.6 - En este punto, si vamos al panel de CloudTrail, veremos que nuestro registro de seguimiento se ha guardado correctamente. Además, podremos ver que se ha creado un Bucket S3 nuevo para persistir todos los datos de la traza.

![Crear traza 3](./img/crear_traza_3.PNG)

### Consultas via CLI

Para consultas rápidas, podemos utilizar el comando `aws cli lookup-events`, aunque, este solo nos devolverá datos que hayan ocurrido en un intervalo de 90 días. 
Por ejemplo, podemos consultar los eventos que hagan referencia a un Login de la Consola:

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin
```
Recuerda que podemos filtrar la petición con el parámetro `query`, para que nos devuelva solo los campos que nos interesan. Por ejemplo:

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=ConsoleLogin --query 'Events[].[Username,EventTime,CloudTrailEvent]'
```
Para cada evento devuelve la persona que ha hecho login, el timestamp y el evento de cloudtrail en string, con formato JSON.




Revisa la documentacion de AWS referente al método lookup-events (https://docs.aws.amazon.com/cli/latest/reference/cloudtrail/lookup-events.html) y intenta escribir un comando de CLI que devuelva información referente a los eventos de creación de un bucket S3 (`CreateBucket`), con el siguiente formato de salida:
```json
[
    [
        "<Username>",
        <Timestamp>,
        [
            "<Nombre del Bucket>"
        ]
    ],
```
<details><summary>Solución</summary>

```bash
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=CreateBucket --query 'Events[].[Username,EventTime,Resources[].ResourceName]'
```
</details>

### Consultas via Athena

Hacer consultas de CloudTrail vía CLI nos puede servir para un momento determinado, pero como habéis visto, la información es difícil de procesar, además de estar limitada a 90 días.

Si os acordáis, anteriormente hemos creado una traza de CloudTrail que guarda datos en un Bucket en formato comprimido `.gz`. Con Athena podemos consultar estos datos utilizando SQL.

3.1 - Primero, crearemos una tabla de Athena a partir de la traza.

![Crear_tabla_athena](./img/create_tabla_athena1.PNG)

![Crear_tabla_athena_2](./img/create_tabla_athena2.PNG)

3.2 - A continuación, accedemos al servicio de Athena para ver y consultar la tabla que acabamos de crear.

![Consulta_athena](./img/consulta_athena.PNG)

3.3 - Accedemos al Editor de consultas (`Query Editor`), pero antes, debemos configurar el Bucket de resultados.

![Consulta_athena](./img/consulta_athena_3.PNG)

3.4 - Ahora, ya podemos consultar las trazas con SQL básico. Puedes crear una consulta que devuelva los intentos de acceder a la consola (`ConsoleLogin`), incluyendo los campos:
 * Cuenta
 * Información del navegador
 * IP de origen
 * Timestamp

Ordenado por Timestamp, de mayor a menor. Recuerda que puedes acceder a la información de las columnas de la tabla

![Consulta_athena](./img/info_add_athena.PNG)

<details><summary>Solución</summary>

```sql
select useridentity.principalid, useragent, sourceipaddress, eventtime from cloudtrail_logs_aws_cloudtrail_logs_xxxx where eventname = 'ConsoleLogin' order by eventtime desc;
```

</details>

### Ejemplo práctico

Recibimos una llamada del departamento de finanzas, la factura de este mes de AWS se ha disparado. Revisando los informes de costes, podemos ver que precio aumenta considerablemente posterior al despliegue de la API de que encontró nuestro amigo Juan. Vamos a descubrir que ha pasado exactamente.

Primero, desplegaremos la API mediante Terraform

4.1 - Clonaremos el repositorio de Terraform

```bash
git clone https://github.com/TheMatrix97/suspicious-api-tf
```

4.2 - Desplegamos la aplicación

```bash
cd src
terraform init
terraform apply
```
Podremos ver el DNS público de esta instancia en la salida del Terraform: `instance_public_dns = "ecx-x-xxx-xx-xxx.compute-1.amazonaws.com"`

4.3 - Esperamos un minuto a que se acabe de desplegar y accedemos via web. Deberiamos obtener el siguiente mensaje:
```txt
Hello World! Try /cat to receive a cool kitty image
```
4.4 - Parece que la API que ha propuesto nuestro compañero funciona tal y dice. Accedemos a `/cat` para ver si nos devuelve una foto de un gato...

![neko_img_1](./img/cat_1.PNG)

4.5 - La aplicación ha hecho algo más sin darnos cuenta? Revisa las llamadas a la API con CloudTrail utilizando Athena para identificar un comportamiento indebido. Enumera la actividad inusual generada por la aplicación

<details><summary>Solución</summary>

```sql
select eventtime, eventname, requestparameters from '<cloudtrail table>' where useridentity.arn like '%i-<id_instance_api>%' order by from_iso8601_timestamp(eventtime) desc;
```

Ejemplo:
```sql
select eventtime, eventname, requestparameters from cloudtrail_logs_aws_cloudtrail_logs_701284289689_76f6d4a1 where useridentity.arn like '%i-0fe770cb48ec0c411%' order by from_iso8601_timestamp(eventtime) desc;
```

Devuelve:

```json
[{
    "eventname": "RunInstances",
    "requestParameters": {"CryptoMiner EC2 VM..."}
},
{
    "eventname": "CreateBucket",
    "requestParameters": {"bucket_name": "random-val-{uuid4}..."}
}]
```

Crea una VM EC2, con el nombre de `CryptoMiner` junto a un Bucket S3 que contiene un fichero.

</details>

4.6 - Reflexiona sobre que acciones llevarías a cabo para evitar que algo así volviera a pasar? 

4.7 - Para deshacer los cambios que ha ocasionado la API, accederemos al endpoint `/enough`. Revisa que efectivamente se han deshecho los cambios que has detectado anteriormente.

4.8 - Limpia el entorno de AWS con el comando `terraform destroy` para eliminar la VM y recursos asociados que hemos creado para servir la API.




