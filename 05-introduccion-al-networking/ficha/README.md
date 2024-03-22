# Ficha del módulo

Antes de comenzar a desplegar recursos en AWS es importante pensar como van a ser nuestros entornos a nivel de red. Establecer qué necesidades tenemos, nos ayudará a definir la Landing Zone sobre la que haremos crecer nuestras aplicaciones y servicios.
Estabelecer las comunicaciones no solo dentro de los entornos en AWS, sino hacia el exterior y añadir una primera cadapa de seguridad nos permitira tener una base sólida sobre las que empezar a construir los diferentes recursos en nube pública, como EC2, S3, etc.


## Módulos anteriores

* Autenticación y autorización


## En este módulo

### Objetivos

* Repasar y consolidar conceptos generales de networking
* Entender cómo se estructura y define AWS a nivel de red
* Conectividad a internet desde VPC
* Comunicaciones intra e inter VPC
* Conceptos básicos de seguridad nativa 

### Conceptos tratados

- [x] VPC
- [x] Rango principal
- [x] Rangos adicionales
- [x] Internet gateway
- [x] subnets
- [x] Security Groups
- [x] nACLs
- [x] Route tables
- [x] Subnets públicas y privadas
- [x] NAT gateway
- [x] Introducción de la función Session Manager de System Manager
- [x] ENIs
- [x] VPC endpoints
- [x] VPC peering
- [x] Costes de transferencia
- [x] Introducción a alto nivel de Transit Gateway

### Quizzes

* https://quizizz.com/admin/quiz/5e5cf48a70acd6001dc628f5
* https://quizizz.com/admin/quiz/5e5cf4d8fd5794001b4e90d4

### Storytelling

*Antes de comenzar a mover nuestras cargas a CCPP, desde nuestra infraestrucurta actual, basada en una serie de servidores mantenidos de fomra tradicional en colo,
tendremos definir una estrategia de migración y establecer la Landing Zone.*

*El substrato sobre el que se crea una solución basada en IaaS es la red, y será presentada como una forma de establecer el perímetro de la infraestructura, la valla
del vecindario. Tendremos que refrescar conceptos generales red y veremos como se adapta el patrón DMZ tradicional a cloud.*

*Por otro lado veremos también que las redes no tienen el mismo significado en una pyme o startup respecto a grandes corporaciones. En las primeras lo ven de una
manera puramente utilitaria mientras que las segundas suelen basar buena parte de sus prácticas de gobernanza y seguridad en una compleja arquitectura de red.
Teniendo en cuenta esto definiremos nuestra arquitectura según nuestras necesidades.*

## Grabaciones

### Introducción al networking

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/pU4QE1YxoYM/0.jpg)](https://www.youtube.com/watch?v=pU4QE1YxoYM)

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/EkmsLyEqbH8/0.jpg)](https://www.youtube.com/watch?v=EkmsLyEqbH8)

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/uvN9oLGUKk8/0.jpg)](https://www.youtube.com/watch?v=uvN9oLGUKk8)




