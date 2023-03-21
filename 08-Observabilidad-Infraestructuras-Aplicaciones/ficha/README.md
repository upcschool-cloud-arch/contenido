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
* Aprender acerca de la monitorización de arquitecturas de microservicios con trazas

### Conceptos tratados

- [x] Cloudwatch Metrics
- [x] Cloudwatch Alarms
- [x] Cloudwatch Logs
- [X] Athena
- [x] SNS
- [ ] CloudTrail 
- [ ] X-ray

### Storytelling

*Hace unos meses, el cliente adoptó un modelo de despliegue ágil, aplicando políticas y buenas practicas GitOps. Esto ha incrementado el número de despliegues a producción, ya que nuestra confianza en cada versión ha incrementado notablemente. Aunque, recientemente se están incrementando el número de quejas de los usuarios, dado un aumento significativo de errores y fallos de rendimiento. El problema, es que actualmente, no disponemos de ningún sistema de monitorización que nos permita evaluar y detectar errores en tiempo real, solo tenemos el feedback del usuario final.*

*Dada esta problematica, el cliente nos encarga crear un sistema de monitorización y implementar una mejor trazabilidad del flujo de peticiones*

