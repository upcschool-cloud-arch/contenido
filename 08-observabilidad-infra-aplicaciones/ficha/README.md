# Ficha del módulo

Aunque parezca mentira, a veces la observabilidad se deja en un segundo plano en despliegues cloud. Consecuentemente, nuestra visión del estado de la infraestructura se ve nublada, imposibilitando la detección de errores inminentes o degradaciones en la calidad del servicio que proveemos. 
Durante el transcurso de este módulo estudiaremos las opciones de monitorización que nos proporciona el cloud de forma nativa en todos sus modelos de uso, tanto IaaS hasta SaaS. De forma complementaria, trataremos herramientas para la creación de Dashboards en tiempo real y alarmas, que nos permitirá tenerlo todo bajo control.

## Módulos anteriores

Arquitectura de aplicaciones tradicionales

## En este módulo

### Objetivos

* Familiarizarse con el uso de Cloudwatch para monitorización en entornos de producción
* Identificar las métricas clave a monitorizar
* Familiarizarse con el Uso de Cloudtrail para monitorizar las llamadas a la API de AWS
* Saber diferenciar entre métricas, logs y trazas
* Aprender acerca de la monitorización de arquitecturas de aplicaciones y microservicios con trazas
* Conocer el `state of art` de los servicios de monitorización utilizados en el mundo empresarial más allá de AWS

### Conceptos tratados

- [x] Cloudwatch Metrics
- [x] Cloudwatch Alarms
- [x] Cloudwatch Logs
- [x] EventBridge
- [X] Athena
- [x] SNS
- [x] CloudTrail 
- [x] X-Ray
- [x] Cloudwatch Synthetics
- [x] AWS Managed Grafana
- [x] Herramientas externas a AWS


### Quizzes

* https://quizizz.com/admin/quiz/6546358a6b8be01266d8caef?source=quiz_share
* https://quizizz.com/admin/quiz/65463612f61c99a35cb7f1f7?source=quiz_share

### Storytelling

*Hace unos meses, el cliente adoptó un modelo de despliegue ágil, aplicando políticas y buenas prácticas GitOps. Esto ha incrementado el número de despliegues a producción, ya que nuestra confianza en cada versión ha incrementado notablemente. Aunque, recientemente se están incrementando el número de quejas de los usuarios, dado un aumento significativo de errores y fallos de rendimiento. El problema es que actualmente, no disponemos de ningún sistema de monitorización que nos permita evaluar y detectar errores en tiempo real, solo tenemos el feedback del usuario final.*

*Dada esta problemática, el cliente nos encarga crear un sistema de monitorización e implementar una mejor trazabilidad del flujo de peticiones*

