# OBJETIVO 

Vamos a constuir nuestra propia imagen. Ya hemos visto un ejemplo. Ahora construye una tú con los  siguientes requisitos

## Requisitos

- [x] No necesitamos una recopilación de datos exhaustiva (Enhanced metadata collection
- [x] La compilación se tiene que realizar cada Sábado a las 1AM UTC y las actualizaciones de dependencias se harán de acuerdo con la programación habitual.
- [x] Tendrá una etiqueta cuya clave será "student" y cuyo valor será tu nombre y apellido en formato - nombreapellido
- [x] Se tratará de una AMI de Amazon Linux 2 ARM64
- [x] La versión del Sistema operativo debe ser la última disponible
- [x] Queremos que la imagen venga con el agente de Cloudwatch preinstalado al igual que con la vesrsión 2 de la CLI de amazon
- [x] Además, desde desarrollo nos indican que necesitarán la versión 8.2 de PHP
- [x] La imagen deber realizar un sencillo test de arranque cuando se ejecute la pipeline
- [ ] IMPORTANTE: Le vamos a asignar un volumen de 8GiB pero nos aseguraremos de que esté marcada la casilla "Delete on termination"
- [x] Usaremos un flujo de trabajo predeterminado
- [x] Crearemos una configuración de infraestructura con los valores por defecto del sistema
- [x] Crearemos una configuración de distribución con valores predeterminados del sistema

Después de crear nuestra Imagen lanzaremos el proceso (Run pipeline) y veremos cómo se levanta una instancia de las características indicadas.
