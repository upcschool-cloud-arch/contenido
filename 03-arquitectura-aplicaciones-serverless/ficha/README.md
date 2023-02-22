# Ficha del módulo

A veces lo que nos olvidamos como ingenieros de software es que lo que realmente necesitamos es resolver un problema de negocio. Nos enfocamos en instalaciones técnicas muy complejas o en intentar hacerlo todo nosotros. Cuando a nuestro cliente final realmente eso no le importa. Hay que recordar que lo más importante es siempre dar valor de negocio, resolver el problema que nuestros clientes quieren que resolvamos. Para eso los servicios serverless o gestionados por la nube nos pueden ayudar. Hay muchisimos tipos de servicios serverless y los podemos integrar unos con otros de muchas formas diferentes, para resolver problemas de negocio pero también para resolver otros problemas de infrastructura.

En este modulo vamos a introducir que son servicios serverless, y vamos a aprender muchos de ellos.

## Módulos anteriores

- Cómo funciona el API de AWS
- Autenticación y autorización
- AWS CLI
- AWS S3
- Amazon Cloudfront

## En este módulo

### Objetivos

- Entender cuales son la ventajas y los usos servicios serverless
- Entender las ventajas y los usos de las arquitecturas orientadas a eventos
- Aprender a usar la AWS SDK y AWS API para integrar servicios gestionados entre si
- Conocer multiples servicios y como navegar la consola y documentación de AWS

### Conceptos tratados

- [x] Serverless
- [x] AWS Lambda como servicio de computo serverless
- [x] Observabilidad de aplicaciones con AWS CloudWatch
- [x] Amazon DynamoDB como bases de datos serverless
- [x] Amazon DynamoDB como bases de datos serverless
- [x] Uso de AWS SDK
- [x] AWS SNS para enviar notificicaciones
- [x] AWS Step Functions como servicio serverless para orquestar aplicaciones
- [x] Amazon EventBridge como servicio serverless de bus de eventos

### Storytelling

Uno de los procesos más críticos en nuestra empresa consiste en procesar una serie de archivos de manera automática. Actualmente se lleva a cabo
utilizando un servidor FTP, en el que un [cron job](https://www.hostinger.es/tutoriales/cron-job) se encarga de determinar los nuevos archivos
y transformarlos adecuadamente.

Lo cierto es que este mecanismo falla en bastantes ocasiones y requiere continuamente intervenciones manuales para recuperarse de los problemas.
Además, hay días en los que la carga de trabajo es superior a la media y esto tiene un fuerte impacto en el rendimiento general del tratamiento.
Por último, los usuarios finales de los ficheros están hartos de tener que ir comprobando si sus datos están disponibles manualmente, y han
reclamado en varias ocasiones recibir una notificación cuando este hecho se produzca.

Nos han pedido que busquemos una solución en el cloud que arregle todos estos inconvenientes y que sea suficientemente flexible para permitir
evolucionarla fácilmente en el futuro.
