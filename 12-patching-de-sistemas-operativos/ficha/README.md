# Ficha del módulo

A pesar de que el acceso remoto a los servidores debería considerarse una excepción cuando nos centramos en una infraestructura como código, tenemos que ser capaces de hacer troubleshooting de instancias conectándonos directamente a ellas cuando la situación lo requiera. Debemos saber qué opciones existen a la hora de conectarse a nuestros servidores y qué servicios de AWS facilitan esa tarea.

En caso de que sea necesario, también debemos ser capaces de parchear nuestras instancias y hacer configuraciones a mayor escala con flotas de servidores y entender cómo podríamos logarlo de forma óptima en AWS.

## Módulos anteriores

* Arquitectura de aplicaciones asíncronas - Javi:  20 de diciembre
* Control y gestión de costes - Samu: 18 de Diciembre

## En este módulo

### Objetivos

* Entender que la conexión remota a los servidores debería ser nuestra última opción.
* Ver qué alternativas tenemos para conectarnos a nuestras instancias.
* Aprender sobre SSH, RDP y las keypair.
* Aprender sobre qué es Systems Manager, sus funcionalidades enfocadas al acceso remoto a los servidores y qué ventajas oferece.
* Aprender a entender para qué se usa Image Builder
* Aprender para qué podemos usar AWS Config cuando tratamos con instancias.

### Conceptos tratados

- [x] EC2
- [x] Cloud native / cloud based
- [x] Servidor / Instancia
- [x] Acceso remoto
- [x] SSH
- [x] Clave SSH pública
- [x] Clave SSH Privada
- [x] RDP
- [x] Systems Manager
- [x] Systems Manager Patch Manager
- [x] Systems Manager Run command
- [x] Systems Manager Session Manager
- [x] Systems Manager State Manager
- [x] Systems Manager Documentation
- [x] EC2 Instance Connect
- [x] EC2 Instance Connect Endpoint
- [x] AWS Image Builder
- [x] AMI
- [x] Image pipeline
- [x] Base image
- [x] Components
- [x] Image recipe
- [x] Parent image
- [x] AWS Config

### Storytelling

*Nos comunican que en teoría se ha desplegado un NGINX en una de las instancias del cliente pero por algún motivo al acceder a la URL designada no vemos nada, es decir el servicio no está funcionando. Tenemos que acceder a la instancia y ver qué ha ocurrido y cómo podemos hacerlo funcionar*

*Nuestra infraestructura empieza a crecer y debido a eso debemos iniciar el uso de una Golden Image que podamos implementar donde sea necesario. Utilizando Image Builder de AWS tendremos que crear, customizar, securizar y testear la imagen que finalmente vamos a usar*
