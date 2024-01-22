# Ficha del módulo

En los viejos tiempos la mayoría de las aplicaciones de una empresa
escribían en la misma base de datos, de manera centralizada. Y, por supuesto,
se trataba de una base de datos relacional.

A día de hoy tratamos de desacoplar sistemas independientes en bases
de datos distintas, y no nos limitamos a una única manera de tratar la
información estructurada (o semiestructurada).

En este módulo veremos algunas características de bases de datos no
basadas en sql.

## Módulos anteriores

- Infraestructura básica, VPC, ALB, EC2, etc
- Bases de datos relacionales y RDS

## En este módulo

### Objetivos

* Entender la necesidad del proceso de automatización del despliegue de aplicaciones
* Comprender cómo aplicar la automatización de pipelines a software e infraestructura
* Discernir qué mecanismo de despliegue es más adecuado para cada situación

### Conceptos tratados

- [x] Bases de datos no relacionales
- [x] Mecanismos de representación de la información 
- [x] Cachés
- [x] Lazy loading pattern
- [x] ElastiCache
- [x] Memcache
- [x] Redis
- [x] DynamoDB
- [x] Particionado
- [x] Costes de DynamoDB
- [ ] Elastic y OpenSearch
- [ ] Neptune

### Quizzes

* TBD

### Storytelling

El equipo de producto se nos acerca para preguntarnos si podríamos sugerir
al de desarrollo algún mecanismo para mejorar una aplicación de la que los
usuarios están continuamente quejándose por la lentitud con la que ejecuta
las peticiones.

En una reunión de trabajo, la lead developer nos explica que es un proyecto
sencillo: ALB + ASG + RDS (Oracle), pero que es cierto que las consultas
que ejecutan no están especialmente optimizadas y en algunas ocasiones
son recursivas, por lo que el servidor de bases de datos suele tener la
CPU saturada.

También queda claro que la mayor parte del trabajo se produce generando
reports que en muchas ocasiones comparten las mismas consultas, y que no
es necesario incluir en tiempo real los datos al tratarse de información
histórica.

Les sugerimos añadir una capa de caché a la aplicación, implementando
el patrón conocido como [Lazy loading](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/Strategies.html#Strategies.LazyLoading). De esta manera los
cambios en la aplicación seran mínimos y el incremento de coste debería resultar
mucho más asumible que sustituir el tipo de instancia por uno mayor.

Por otro lado, en desarrollo se plantea una revisión del carrito de la compra: convertirlo en un microservicio que sea independiente y mucho más eficiente que el actual. Dado que los patrones de acceso son muy conocidos, pensamos que DynamoDB sería una buena opción de cara a almacenar los datos durante la parte transaccional del workflow.
