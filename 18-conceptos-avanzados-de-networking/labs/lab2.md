# Laboratorio de Redes Avanzadas

## Laboratorio 2: Configuración de un Transit Gateway

### Limitaciones
Antes de empezar es necesario recalcar que en AWS Academy carece de los privilegios necesarios para poder hacer un Transit Gateway entre dos zonas diferentes, el problema es que el usuario IAM no los tiene y no los podemos cambiar. Por este motivo vamos a establecer el Transit Gateway entre dos VPC diferentes de North Virginia. Para conectarnos a Oregon usaremos el Peering del Lab 1.

### Escenario
En vista que a medida que crece la compañía, establecer Peering connections se ha vuelto un problema, se ha decidido buscar una alternativa. En AWS la mejor opción es el Transit Gateway, que proporciona:
* Un modelo Hub-Spoke más real
* La posibilidad de establecer políticas entre los diferentes sites por seguridad
* Propagación automática de rutas

El punto de partida de este laboratorio son la instancia de EC2 que se creó en el Lab 1, el VPC 10.100.0.0/16 en la misma, el Peering hecho con Oregon y toda la infrastructura que tenemos allá.

### Creación del Transit Gateway
En la vista de VPC vamos a "Transit Gateways" > "Transit Gateway" > Create transit gateway

Es importante remarcar que el Transit Gateway está pensado para escalar a infrastructuras muy grandes, es por esto que permite especificar, y formar parte de un sistema autónomo (Autonomous System - AS), el detalle de las implicaciones de esto salen fuera de este curso introductorio.

Así durante la creación especificaremos las siguientes opciones:
* Default route table association
* Default route table propagation

Se pueden activar el resto pero no se van a usar durante el laboratorio, por lo que dejaremos los valores por defecto.

Es importante remarcar que usar la opción de asociación automática de las tablas de routing va a implicar que todas las asociaciones compartan tabla de routing, a la práctica esto no está recomendado si queremos limitar las políticas de routing entre sitios. Pero dejamos esta parte para el Lab 3.

Para este lab dejamos que investiguéis vosotros como hacerlo con lo visto en la teoría, a modo de resumen lo que se tiene que hacer es:
* Asociar cada VPC y el Peering con el Transit Gateway
* Asegurarnos que las rutas se han propagado

Con esto conseguimos que las tablas de routing del Transit Gateway permitan una topología en estrella sin problemas, ahora solo hace falta decidir qué redes querememos que se puedan mandar a través de él.

**Nota importante:** Los Transit Gateways no tienen acceso a Internet por defecto, por lo que nos convendrá enviar solo el tráfico interno de la compañía a través de él.
