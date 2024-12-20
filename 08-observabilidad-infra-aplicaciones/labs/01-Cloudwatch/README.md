# Lab 8.1 - Cloudwatch

## Storytelling

Las modas son cíclicas, y actualmente se está percibiendo un nuevo boom de Pokemon Go, nuestra empresa ha decidido publicar un servicio web que ofrece información relativa a la Pokedex. De esta manera, el CEO puede publicitar su empresa dentro de los círculos de jugadores de Pokemon. 

Resulta que la aplicación está gustando, aunque algunas personas se quejan de errores puntuales. Dado que no tenemos ningún sistema de monitorización activado no podemos encontrar la causa de estos errores.

Dada la situación, el equipo de infraestructura, del que somos parte, ha decidido implementar mecanismos para monitorizar y detectar los errores de nuestra aplicación. 


## Objetivo
Es esta práctica, aprenderemos a monitorizar aplicaciones e infraestructura utilizando las herramientas SaaS que nos ofrece AWS. 
Conoceremos los principios básicos de CloudWatch para el análisis de métricas y logs. También veremos las posibilidades que nos ofrece CloudWatch Alarms junto con EventBridge para el tratamiento de eventos inesperados.

## Creación del entorno

En esta práctica partiremos de un entorno simple con una única VM EC2. Esta máquina virtual tiene instalado un servidor NGINX con una web estática generada a partir del framework Angular.

Primero, clonaremos el repositorio con la aplicación:

```bash
$ git clone https://github.com/TheMatrix97/pokedex-tf-app
$ cd ./pokedex-tf-app/src
```

Desplegamos nuestra aplicación con Terraform

```bash
$ terraform init && terraform apply
```
Si todo ha ido bien, el script de Terraform nos devolverá el host de nuestra aplicación, desplegada en una nueva instancia EC2.

> Nota: La aplicación se expone en el puerto 80 (http)

Accediendo vía web, deberíamos ver algo parecido a esto:

![Screenshot app web](./img/captura_pokeapp.PNG)


## Lab

1-

Antes de nada, activaremos la opción "Manage detailed monitoring" para poder obtener datos de monitorización en intervalos de 1 minuto para incrementar el número de datos que recibimos.
![Screenshot monitoring 1](./img/act_detailed_monitoring.png)

![Screenshot monitoring 2](./img/act_detailed_monitoring_2.png)

Como podéis ver en la pestaña monitoreo dentro del panel de EC2, podemos ver un pequeño resumen de las métricas disponibles.

2- 

Navegaremos hacia **CloudWatch > Metrics > All metrics**. Dónde podemos hacer una búsqueda por 'id' de instancia para poder obtener todas las métricas asociadas a nuestra aplicación. 

![Screenshot metrics explorer](./img/cloudwatch_metrics.png)

> Al seleccionar una métrica podéis modificar la visualización en el apartado `Graphed metrics`. Tened en cuenta que por defecto utiliza un período de `5 minutos`

Echar un vistazo de las métricas disponibles, ¿echáis en falta alguna?
Como podéis ver, aquí faltan métricas importantes. En concreto, todas aquellas que nos podemos encontrar a nivel de sistema operativo, 
como por ejemplo, el espacio disponible de disco. 
Para ello, tenemos que instalar **CloudWatch Agent**

### Instalación de CloudWatch Agent

3-

A continuación, instalaremos CloudWatch Agent en nuestra máquina. Para ello, introduciremos el servicio **AWS Systems Manager**, que nos permite la instalación de paquetes de forma remota sin acceder vía SSH.

3.1-

Haciendo uso del buscador, accederemos al servicio de **AWS Systems Manager** (https://us-east-1.console.aws.amazon.com/systems-manager/home?region=us-east-1)

3.2-

Una vez ahí, buscaremos la opción `Run command` bajo el apartado `Node Management`

![Screenshot systems manager](./img/aws_sys_manager_run_command.png)

![Screenshot systems manager11](./img/aws_sys_manager_run_command_1.1.png)

3.3-

Buscaremos el paquete `AWS-ConfigureAWSPackage`, lo seleccionamos y nos vamos a la parte inferior a configurar las opciones.

![Screenshot systems manager 2](./img/aws_sys_manager_run_command_2.png)

3.4-

Indicamos el paquete a instalar con su versión: `AmazonCloudWatchAgent`, `latest`

![Screenshot systems manager 3](./img/aws_sys_manager_run_command_3.png)

3.5 -

Seguidamente, seleccionamos el `target`, que en nuestro caso será la instancia `PokeApp`, y ejecutamos el comando haciendo click a la opción `Run` del final de la página.

![Screenshot systems manager 4](./img/aws_sys_manager_run_command_4.png)

Si todo ha ido bien, veremos que el comando acaba con estado `correcto`, haciendo click sobre el ID de la instancia podemos acceder a los logs de ejecución para verificar que todo ha ido bien.

![Screenshot systems manager 5](./img/aws_sys_manager_run_command_5.png)


Ahora mismo, nuestra instancia de EC2 dispone del agente de CloudWatch, pero no tiene ningún tipo de configuración. A continuación, vamos a definir una configuración para obtener los logs del servidor web Nginx junto a métricas relevantes. Puedes consultar la [Documentación](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html) para más información acerca del significado de cada campo.
```json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "log_group_name": "NginxAccessLog",
            "file_path": "/var/log/nginx/access.log",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%d/%b/%Y:%H:%M:%S %z"
          },
          {
            "log_group_name": "NginxErrorLog",
            "file_path": "/var/log/nginx/error.log",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%Y/%m/%d %H:%M:%S"
          }
        ]
      }
    }
  },
  "metrics": {
    "aggregation_dimensions": [
      ["InstanceId"]
    ],
    "append_dimensions": {
      "InstanceId":"${aws:InstanceId}"
    },
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "metrics_collection_interval": 10,
        "totalcpu": true
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "metrics_collection_interval": 10,
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time"
        ],
        "metrics_collection_interval": 10,
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ],
        "metrics_collection_interval": 10
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ],
        "metrics_collection_interval": 10
      }
    }
  }
}
```
4.1 - 

Accederemos a **AWS Systems Manager > Parameter Store > Create parameter**, para crear la configuración que posteriormente enviaremos al agente. Dentro del campo **Value** añadiremos la configuración en Json que podemos encontrar en el paso anterior.
![Crear parametro](./img/crear_parametro.png)

4.2 - 

Seguidamente, lanzaremos el comando de actualización de la configuración entrando en el apartado **AWS Systems Manager > Run command > AmazonCloudWatch-ManageAgent**. Dónde debemos incluir el nombre del parámetro que hemos creado anteriormente e indicar nuestra instancia PokeApp como `target`, siguiendo el mismo procedimiento del punto 3.5
![Reconfigure Agent](./img/reconfigure-agent.png)

### Monitorización de logs de aplicación

5.1 -

En este punto, si todo ha ido bien, deberíamos de ver que nuestro agente de CloudWatch está exportando correctamente los logs del servidor web.
**CloudWatch > Log groups > NginxAccessLogs**
![Agent Access Logs](./img/nginx-access-logs.PNG)
![Agent Access Logs](./img/nginx-access-logs_1.PNG)
En el campo mensaje podemos observar el contenido de la línea de logs exportada. Además, como podéis observar, se parsea el `timestamp` de cada entrada para poder filtrar por tiempo, acorde a la configuración que hemos visto anteriormente.

5.2 -

Nuestra aplicación tiene una parte que no acaba de funcionar bien, parece que se trata de una funcionalidad que aún no está del todo operativa. Es el `endpoint` `/digimon`. Prueba a acceder y observa como aparecen los logs de las peticiones devolviendo errores `500`.

5.2.2 -

Para poder ver los logs en tiempo real, accede a `CloudWatch > Live Tail` y configura el filtro para obtener los errores 500 del `NginxAccessLog`, tal y como se muestra a continuación
![Agent Access Logs](./img/nginx_live_tail.png)

> Haz algunas peticiones más a `/digimon`, aparecen los errores?


### Métricas derivadas de logs

5.3 -
A continuación, crearemos una métrica que nos indique el número de errores 500 en los logs. Para ello accedemos a **CloudWatch > Log groups > NginxAccessLogs > Actions > Create metric filter**
![Crear filtro metricas](./img/nginx_log_evento_registro.PNG)

A continuación, introducimos el patrón a utilizar, en nuestro caso será `[ip, id, user, timestamp, request, status_code=5*, size]`, de manera que solo se contabilizaran las entradas con error `5XX`, añadiendo un valor de 1 a la métrica, tal como se muestra a continuación:
![Crear filtro metricas 2](./img/crear_filtro_2.PNG)

> Haz click en la opción `Test Pattern` para verificar que el filtro funciona correctamente

![Crear filtro metricas 3](./img/crear_filtro_3.PNG)

**¿Puedes encontrar un comando de AWS CLI para crear un filtro de métricas?**

<details><summary>Solución</summary>

```bash
# Create a filter
aws logs put-metric-filter \
  --log-group-name NginxAccessLog \
  --filter-name 500Errors \
  --filter-pattern "[ip, id, user, timestamp, request, status_code=500, size]" \
  --metric-transformations \
  metricName=Metric500Test,metricNamespace=MetricasLog,metricValue=1,defaultValue=0
```

</details>

5.4 - 

Si accedemos al apartado de consultas de métricas `CloudWatch > Metrics > All metrics`, podremos observar que la métrica captura correctamente el número de errores 500.
> Nota: La métrica no aparecerá si aún no hay datos

![Observar_valor_metrica](./img/visualizacion_metrica_custom.PNG)

### Alarmas
En este apartado crearemos una alarma a partir de la métrica que hemos definido anteriormente, lanzando una alerta si se detecta un número determinado de errores en un intervalo de tiempo predefinido.

6.1 -

Para ello, accederemos a **CloudWatch > Alarms > All alarms > Create alarm**, seleccionaremos la métrica que hemos creado antes, en nuestro caso, `500Errors`. Configurando la condición de activación con los siguientes parámetros:
* Estadística: Suma
* Período: 1 minuto
* Tipo de límite: Estático
* Condición: Mayor (>) 10

![Crear nueva alarma](./img/create_new_alarm.png)

6.2 -

Seguidamente, definiremos la acción a ejecutar, en nuestro caso, lo configuraremos para que envíe un mensaje cuando la condición se cumpla, mediante SNS.

![Observar_valor_metrica](./img/sns_create_new.PNG)

**Importante**: En este punto, tendremos que ir nuestro correo electrónico para confirmar la subscripción al tema de SNS que hemos creado.

En este punto, deberíamos de poder acceder a **CloudWatch > Alarmas** y ver la Alarma que acabamos de crear.

![Alarma_creada](./img/alarm_creada.PNG)

6.3 -

Vamos a intentar hacer que salte la alarma, vamos a acceder repetidamente al endpoint `/digimon` de nuestra pokeapp para generar errores 500 y hacer saltar la alarma.

En un minuto, deberíamos de ver como nuestra alarma pasa a modo alarma y recibimos un mail parecido a este:

![Alarma_creada](./img/mail_notificacion.PNG)


## Bonus 1 (Opcional)
Crea un panel que refleje las métricas **USE** de la instancia **PokeApp** para poder monitorizarla fácilmente. Te recomiendo que utilizes las métricas del grupo `CWAgent`, estas són las que recolecta el agente de cloudwatch.
Al final deberías de acabar con un panel como el que se muestra a continuación  
![USE Schema](./img/USESchema.PNG)

En este se deberan reflejar las siguientes métricas:
* **Utilization**: (CPU) -> cpu_usage_user, cpu_usage_iowait, cpu_usage_system
* **Saturation**: (Memoria) -> mem_used_percent
* **Errors**: Número de errores 500

Es recomendable utilizar un **periodo de 1 minuto** para visualizar las métricas

### Generación de tráfico sintético

Podéis utilizar la herramienta `k6` (**Es opcional!**) para generar tráfico sintético. Podéis descargar el binario directamente de GitHub

```bash
wget -O- https://github.com/grafana/k6/releases/download/v0.52.0/k6-v0.52.0-linux-amd64.tar.gz | tar -zxvf - --strip-components=1 --wildcards '*/k6' && chmod +x k6
```

Para utilizar esta herramienta debeis diseñar un escenario, como el siguiente.
En este se instancia 50 usuarios de pico. Todos ellos haran una petición a `/digimon`

```bash
cat << EOF > load_test.js
import http from 'k6/http';
import { sleep, check } from 'k6';

const URL = 'http://<DNS PokeApp>';

export let options = {
  stages: [
    { duration: '1m', target: 50 }, // simulate ramp-up of traffic from 0 to 50 users over 1 minute
    { duration: '30m', target: 20 }, // stay at 20 users for 30 minutes
  ],
};

export default function () {
  let response = http.get(URL+'/digimon');
  sleep(1);
  response = http.get(URL);
  sleep(1);
}
EOF
```

## Bonus 2 (opcional)

Si os habéis fijado, la PokeApp está abierta a todo el mundo, por lo que es muy probable que hayamos recibido alguna request de algún bot no deseado... A continuación, vamos a utilizar **Logs Insight** para consultar nuestros logs y obtener todos aquellos que provienen de una ip diferente a la nuestra, a ver si encontramos algún bot!

Acceder a la herramienta y **CloudWatch > Logs > Logs Insights** y con la ayuda de la [documentación](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html), encontrar una consulta que os permita listar todas las peticiones del `NginxAccessLog` que provengan de una IP diferente a la vuestra.


<details><summary>Solución</summary>

```text
fields @timestamp, @message
| filter @message not like "<ip>"
| sort @timestamp desc
```

</details>



