# Ficha del módulo

En general, es mucho más rápido *pedir* que *hacer*. Por ejemplo, si el usuario de la aplicación pide la generación
de un informe, es muy posible que tanto la capa de datos como la de computación se vean sometidas a un estrés
desproporcionalmente alto comparado con la dificultad de pulsar un botón en un menú. Esta asimetría puede
hacer vulnerable a nuestro sistema al proporcionar un mecanismo sencillo con el que sobrecargarlo.

Una posible solución consiste en desacoplar la intención del usuario de su ejecución. Es decir, en apuntar
que el usuario ha llevado a cabo una petición para que el sistema encuentre el momento adecuado en el que
ejecutarla.

Las colas proporcionan un mecansimo de almacenaje temporal en el que apuntar este trabajo pendiente generado
por los *productores* en forma de *mensajes*, que posteriormente pueden ser procesados por los *consumidores*.

## Módulos anteriores

* Arquitectura de aplicaciones serverless
* Arquitectura de aplicaciones tradicionales
* Alta disponibilidad y elasticidad

## En este módulo

### Objetivos

* Entender el concepto de asincronía
* Crear desacoplamientos temporal entre capas de la aplicación
* Distinguir entre las capacidadesd de distintos productos de colas
* Diseñar mecanismos de resiliencia basados en colas
* Amortiguar el  throughput de escritura mediante el uso de colas
* Distinguir entre consumidores basados en EC2 y Lambda
* Entender las mejores métricas para escalar los consumidores


### Conceptos tratados

- [x] Productor
- [x] Cola
- [x] Consumidor
- [x] Push vs Pull
- [x] SQS
- [x] AmazonMQ (RabbitMQ, ActiveMQ)
- [x] Kinesis streams
- [x] AWS IoT Core (MQTT)


### Storytelling

La *product manager* de una de las aplicaciones de back-office que hemos migrado nos felicita por haber conseguido
que funcione lo suficientemente rápido como para que los usuarios dejen de quejarse continuamente por el rendimiento
de la misma.

Sin embargo, desde finanzas nos indican que el coste de la infraestructura para este subsistema ha aumentado
considerablemente, y que debemos tomar medidas para reducir este impacto cuanto antes.

Tras revisar las métricas del sistema se hace evidente que el autoescalado está configurado de forma muy agresiva
para evitar que las operaciones más costosas de la aplicación realenticen el rendimiento general, y por ello
el sistema está claramente sobreaprovisionado.

Tras hablar con el equipo de desarrollo, acordamos que convertir aquellos procesos más pesados en asíncronos
puede ayudar a mantener la flota de la aplicación en un tamaño mucho más eficiente.