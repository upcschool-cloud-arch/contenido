# OBJETIVO 

Vamos a constuir nuestra propia imagen. Ya hemos visto un ejemplo. Ahora construye una tú con los  siguientes requisitos

## Requisitos

- [x] No necesitamos una recopilación de datos exhaustiva
- [x] La compilación se tiene que realizar cada Sábado a las 1AM y las actualizaciones de dependencias se harán de acuerdo con la programación habitual.
- [x] Tendrá una etiqueta cuya clave será "student" y cuyo valor será tu nombre y apellido en formato - nombreapellido
- [x] Se tratará de una AMI de SUSE Linux 15 y arquitectura ARM
- [x] La versión del Sistema operativo debe ser la del 20 de octubre del año pasado
- [x] Queremos que la imagen venga con el agente de Cloudwatch preinstalado al igual que con la vesrsión 2 de la CLI de amazon
- [x] Además, desde desarrollo nos indican que necesitarán la versión 7.3 de PHP
- [x] La imagen deber realizar un sencillo test de arranque cuando se ejecute la pipeline
- [x] Usaremos un flujo de trabajo predeterminado
- [x] Crearemos una configuración de infraestructura nueva en la que usaremos el Rol disponible y desplegaremos instancias tipo t3.small. No seleccionaremos unos valores específicos para la VPC, los SG y las subredes.
- [x] Crearemos una configuración de distribución con valores predeterminados

Después de crear nuestra Imagen lanzaremos el proceso y veremos cómo se levanta una instancia de las características indicadas.