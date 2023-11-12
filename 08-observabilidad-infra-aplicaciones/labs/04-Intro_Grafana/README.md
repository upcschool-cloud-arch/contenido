# Lab 8.4 - Introducción a Grafana

> Este laboratorio es opcional. Está basado en el tutorial [Grafana fundamentals](https://grafana.com/tutorials/grafana-fundamentals/) con algunas modificaciones

## Objetivos
En esta práctica, aprenderemos conceptos básicos de Grafana, Loki y Prometheus. Aportando la base para la monitorización de Métricas y Logs en Grafana y los mecanismos de alarmas que nos proporciona.

## Storytelling
Nuestra empresa está considerando la migración a Grafana para la monitorización de Métricas y Logs. La empresa ha crecido mucho, y ya disponemos de un equipo de infraestructura lo suficientemente grande para poder mantener un stack de monitorización propio. Nos han pedido una prueba de concepto del stack de Grafana + Loki + Prometheus.

## Lab

1- Primero, clonaremos el repositorio de Terraform que despliega el Stack de monitorización junto a la aplicación a monitorizar.

```bash
$ git clone https://github.com/TheMatrix97/Grafana-Tutorial-TF.git
```

2- Desplegaremos el lab con Terraform

```bash
$ cd Grafana-Tutorial-TF/src
$ terraform init
$ terraform apply
```
Estos comandos nos desplegarán una VM t3.medium con los servicios que se muestran a continuación

![Esquema a desplegar](./img/intro_grafana_lab.png)

- **Grafana News**: Aplicación de ejemplo que nos permite publicar links y votar por ellos
- **Grafana News DB**: Servicio de base de datos para la aplicación Grafana News
- **Node_exporter**: Agente de Prometheus que exporta las métricas de la VM Host para Prometheus
- **Promtail**: Agente de Loki, recolecta las métricas de Grafana news y lo manda a Loki
- **Prometheus**: Herramienta de monitorización opensource orientada al almacenaje y consulta de métricas
- **Grafana**: Herramienta de análisis y visualización de dashboards
-  **Loki**: Herramienta de monitorización opensource orientada al almacenaje y agregación de logs.

Puedes ver el stack completo en el docker-compose que encontrarás en: https://github.com/TheMatrix97/tutorial-environment/blob/master/docker-compose.yml

Solamente se expone al exterior `Grafana` en el puerto `3000` y `Grafana News` en el `8081`.

Podremos ver el DNS público de la instancia en la salida del Terraform: instance_public_dns = "ecx-x-xxx-xx-xxx.compute-1.amazonaws.com"

3- Accede a `Grafana news` en el puerto 8081, publica un link y vota por él

![Grafana news dashboard](./img/grafana_news.png)

4- Accede a `Grafana` en el puerto 3000 con `HTTPS` (https://ecx-x-xxx-xx-xxx.compute-1.amazonaws.com:3000) y haz login con las siguientes credenciales:
- **Username**: admin
- **Password**: cloud2023

Si todo ha ido bien, deberíamos de ver la pantalla inicial de Grafana

![Grafana Home](./img/home_grafana.png)

### Métricas

5- Accede al menú de la izquierda. `Connections > Add new connection` y añade Prometheus como fuente de datos, utilizando la URL `http://prometheus:9090` 

![Add prometheus](./img/add_prometheus.png)

Finalmente, haremos click en la opción inferior de `Save & Test` para guardar la configuración y verificar que se puede conectar correctamente. Si te has fijado, estamos utilizando la red interna de Docker que crear el docker-compose, de esta manera evitamos exponer los servicios a internet.

6- Accede al menu `Home > Explore` para explorar los datos que almacena Prometheus. Una vez ahí, seleccionaremos el datasource `Prometheus`, activaremos el modo de refresco automático cada 5 segundos y el modo `Code` para escribir consultas `PromQL` directamente. 
Prueba a consultar `tns_request_duration_seconds_count`

![Explore Prometheus](./img/explore_prometheus.png)

La métrica `tns_request_duration_seconds_count` es de tipo contador, nos dice cuantos valores tenemos registrados de tipo `tns_request_duration_seconds`, en otra palabras, nos indica cuantas peticiones se han hecho al servicio.

Si hacemos la búsqueda, nos deberia devolver datos parecidos a este:
```promql
tns_request_duration_seconds_count{instance="app:80", job="tns_app", method="GET", route="other", status_code="404", ws="false"}
````
Cada una de las lineas que nos devuelve es una serie, si te fijas, prometheus crea una serie para cada conjunto de metadatos que recolecta. De manera que tendremos una serie para por ejemplo las peticiones `GET de /vote` y otra para las `GET de /other`.

6.1- Modifica la consulta por `rate(tns_request_duration_seconds_count[5m])`. Utilizando la función `rate` obtendrás el ratio de peticiones por segundo, en base a los datos obtenidos durante los últimos 5 minutos. Genera trafico en la aplicación `Grafana news` para observar el incremento en el número de peticiones por segundo.

![result_rate](./img/image.png)

Si te fijas, el ratio de peticiones por segundo de `GET /metrics` se mantiene igual. ¿Porque? La configuración de Prometheus que se muestra a continuación, indica que por defecto obtendrá los datos de todos los servicios cada 15s, excepto `Grafana News`, que lo hará cada 5s. 
Eso implica que hará 12 peticiones por minuto a `/metrics` o que es lo mismo `12 / 60 = 0,2 peticiones / segundo`
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"

    static_configs:
      - targets: ["localhost:9090"]
  
  - job_name: "node"

    static_configs:
      - targets: ["node_exporter:9100"]

  - job_name: "tns_app"

    # Override global settings
    scrape_interval: 5s

    static_configs:
      - targets: ["app:80"]
```

6.2 - Utiliza el operador `sum` para agregar los datos por el metadato `route`. 
```promql
sum(rate(tns_request_duration_seconds_count[5m])) by(route)
```
Puedes intentar agrupar por otras etiquetas, como `status_code`, variando la parte `by(route)`.

### Logs

7- Añadiremos el datasource de Loki de la misma forma que en el punto `5`, pero indicando la URL: `http://loki:3100`. Finalmente, haremos click en el botón `Save & Test` para guardar la configuración y revisar la conexión con el servicio

![Add loki ds](./img/loki_ds_config.png)

8- Accedemos al explorador de fuentes de datos, igual que en el punto `6`. Pero, esta vez seleccionamos el datasource `Loki`. Selecionamos el modo `Code` y executamos la siguiente consulta de Loki
```txt
{filename="/var/log/tns-app.log"}
```
Esta consulta nos devolverá todos los logs del fichero `tns-app.log` de `Grafana News`. Además, también mostrará un grafico de barras indicando el número de entradas registradas en relación al tiempo

![source loki](./img/explore_loki.png)

8.1 - Ejecuta la siguiente consulta, para obtener solamente los logs que contengan la palabra `error`.
```
{filename="/var/log/tns-app.log"} |= "error"
```
En principio, no deberia de salir ninguno, ya que no hemos provocado ningún error en la aplicación `Grafana news`. Puedes generar uno al intentar insertar un nuevo post sin ningún valor en el campo `URL`. Activa el Modo Live para poder ver los logs en tiempo real según van llegando a Loki.

### Crear un dashboard



