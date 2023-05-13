# Ficha del módulo

Como arquitecto, a menudo tendrá que elegir entre diferentes tipos de bases de datos cuando considere qué tipo manejará mejor una carga de trabajo en particular. Antes de elegir una base de datos, hay algunas consideraciones clave que deberían aportar información al proceso de toma de decisiones.

En primer lugar, considere la importancia de la escalabilidad. Con las bases de datos tradicionales en las instalaciones, el escalado de la capacidad puede ser una tarea difícil incluso para los administradores de base de datos experimentados. Puede tomar horas, días o semanas. El impacto en el rendimiento de la base de datos mientras se escala puede ser impredecible y puede requerir tiempo de inactividad. Sin embargo, no se puede sobrestimar la importancia de una base de datos escalada correctamente. Si el aprovisionamiento de su base de datos es insuficiente, es posible que las aplicaciones dejen de funcionar. Sin embargo, si el aprovisionamiento de su base de datos es excesivo, aumentará los costos iniciales mediante la adquisición de recursos que no necesita, lo que infringe el principio de optimización de costos de AWS Well-Architected Framework.

Idealmente, debería elegir una solución de base de datos que tenga los recursos para manejar el rendimiento necesario en el lanzamiento y que también pueda escalarse en forma ascendente fácilmente más adelante si debe aumentar su rendimiento.

Otra funcionalidad con la que es agradable contar es la capacidad de escalar en forma descendente la capacidad de la base de datos aprovisionada si los requisitos de rendimiento o la carga de la base de datos disminuyen posteriormente. Esto le permite obtener ahorros de costos inmediatamente reduciendo la capacidad aprovisionada. Una solución de escalado automático podría reducir los costos de sistema y de mano de obra.


## Módulos anteriores

Websites estáticos

Arquitecturas de aplicaciones tradicionales

## En este módulo

### Objetivos

* Consideraciones de la capa de base de datos
* Amazon RDS
* Amazon DynamoDB
* Controles de seguridad de la base de datos
* Migración de datos a las bases de datos de AWS
* Una demostración de la configuración automatizada de copias de seguridad y réplicas de lectura de Amazon Relational Database Service (Amazon RDS).
* Un laboratorio guiado donde puede crear una base de datos de Amazon RDS y conectarse a ella mediante una aplicación web sencilla.
* Un laboratorio de desafíos que lo desafía a migrar datos desde una base de datos que se ejecuta en una instancia de Amazon Elastic Compute Cloud (Amazon EC2) a una base de datos de Amazon RDS.



### Conceptos tratados

- [x] AWS RDS
- [x] AWS Redshift
- [ ] AWS DynamoDB
- [x] DMS
- [X] Seguridad
- [x] S3
- [x] EFS
- [x] EC2


### Storytelling

Desde que la cafetería agregó la posibilidad de realizar pedidos en línea a su sitio web, el personal se dio cuenta de que la actividad aumentó. Además, descubrieron que el historial de pedidos almacenado en la base de datos, que instalaron en la misma instancia EC2 en la que se ejecuta el servidor web, proporciona información valiosa para la empresa. Martha lo usa para fines contables, y Frank lo mira de vez en cuando para hacerse una idea de la cantidad de cada tipo de postre que debe hornear.

Sin embargo, Sofía tiene algunas inquietudes. La base de datos debe actualizarse y se le deben aplicar parches, y ella no siempre tiene tiempo para realizar estas tareas de manera regular. Además, administrar la base de datos es una habilidad especializada, y capacitar a otros para que lo hagan no es algo a lo que ella quiere dedicar tiempo. Mientras tanto, también le preocupa que la cafetería no esté haciendo copias de seguridad de los datos con la frecuencia que se debería.

El personal de la cafetería quiere reducir los costos de mano de obra relacionados con la inversión en aprendizaje técnico que se necesita para administrar la base de datos ellos mismos. Por lo tanto, decidieron que necesitan usar una solución de base de datos administrada. Idealmente, encontrarán una que ofrezca características esenciales, como durabilidad, escalabilidad y alto rendimiento.

En este módulo, aprenderá detalles sobre los diferentes servicios de base de datos que ofrece AWS y las capacidades que proporcionan estos diferentes servicios. Ya que comprende las opciones disponibles, debería poder elegir una solución de base de datos que pueda satisfacer con éxito estos nuevos requisitos empresariales.

