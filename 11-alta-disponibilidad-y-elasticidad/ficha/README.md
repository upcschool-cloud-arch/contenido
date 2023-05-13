# Ficha del módulo

Las aplicaciones modernas deben poder manejar cantidades masivas de datos sin tiempo de inactividad y con tiempos de respuesta que estén por debajo del segundo. Para cumplir estos requisitos, puede implementar un sistema reactivo que sea elástico, resiliente, con capacidad de respuesta y que esté basado en mensajes. Una arquitectura reactiva bien diseñada puede ahorrarle dinero y ofrecer una mejor experiencia a sus usuarios.

En este módulo, aprenderá a crear arquitecturas reactivas en AWS que sean elásticas, resilientes y con capacidad de respuesta. Aprenderá acerca de los componentes basados en mensajes para crear arquitecturas desacopladas en un módulo ulterior.

## Módulos anteriores

Arquitectura de aplicaciones web estáticas

Introducción al Networking

Arquitecturas de aplicaciones tradicionales

## En este módulo

### Objetivos

Este módulo incluye las siguientes secciones:

* Necesidad de arquitectura
* Escalado de los recursos informáticos
* Escalado de las bases de datos
* Diseño de un entorno de alta disponibilidad
* Monitoreo

Este módulo también incluye lo siguiente:

* Una demostración sobre cómo crear políticas de escalado de seguimiento de valores objetivo y de escalado por pasos para Amazon EC2 Auto Scaling
* Una demostración sobre cómo implementar una aplicación web de disponibilidad alta con un balanceo de carga de aplicaciones 
* Una demostración de Amazon Route 53
* Un laboratorio guiado donde creará un entorno de disponibilidad alta
* Un laboratorio de desafíos donde creará un entorno escalable y de disponibilidad alta para la cafetería

Por último, se le solicitará que realice una evaluación de conocimientos, en la cual se determinará su grado de comprensión de los conceptos clave que se habrán analizado en este módulo.


### Conceptos tratados

- [x] ALB
- [x] ASG
- [x] EC2

### Storytelling

Pronto la cafetería aparecerá en un famoso programa televisivo sobre comidas. Respecto de la emisión, Sofía y Nikhil anticipan que el servidor web de la cafetería experimentará un pico temporal en la cantidad de usuarios: tal vez hasta decenas de miles de usuarios más. Hoy el servidor web de la cafetería está implementado en una sola zona de disponibilidad, y tienen miedo de que no pueda manejar el aumento de tráfico previsto. Quieren hacer lo necesario para que sus clientes tengan una experiencia excelente cuando visiten el sitio web y para que no experimenten problemas, como retrasos o retardos a la hora de hacer pedidos. Para garantizar la experiencia que desean, el sitio web debe tener capacidad de respuesta, disponibilidad alta y debe poder hacer un escalado ascendente y descendente para atender la demanda fluctuante de los clientes. También debe incorporar el balanceo de carga. Para poder manejar el aumento de la demanda, en lugar de sobrecargar un único servidor, la arquitectura debe distribuir las solicitudes de pedidos de los clientes entre varios servidores de aplicaciones.


