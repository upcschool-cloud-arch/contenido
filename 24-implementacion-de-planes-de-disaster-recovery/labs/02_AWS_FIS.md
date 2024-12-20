# OBJETIVO 

Vamos a configurar un experimento en AWS Fault Injection Service para poner a prueba una instancia EC2.

## Creamos una EC2

Vamos a crear una instancia EC2 y le vamos a poner un nombre identificativo. Hay que tener en cuenta que todo el mundo va a realizar este LAB al mismo tiempo que tú en la misma cuenta de AWS así que tienes que ser capaz de diferenciar tu instancia de la de los demás.

* Acuérdate de que debemos estar en la región de Irlanda (eu-west-1)

A estas alturas ya sabemos crear una instancia así que ¡adelante con ello! Puedes dejar todos los valores por defecto, usar la AMI de Amazon Linux de siempre y levantar una instancia muy pequeña. Acuérdate de generar un .pem que puedas usar por si queremos conectarnos a nuestra instancia.


## AWS Fault Injection Service

Una vez nuestra EC2 está corriendo vamos al servicio de AWS FIS.

Allí vamos a ir al apartado de *Scenario Library* y seleccionaremos el escenario EC2 Stress: CPU. En la parte de abajo de la consola veremos la información sobre qué hace este escenario en concreto y los requisitos para su implementación

A continuación pulsaremos en "Create template with scenario"

![](images/05.png)

Crearemos el escenario para la *cuenta actual* y NO para múltiples cuentas.

Le cambiaremos el nombre a la plantilla de nuestro experimento para poder saber que es nuestra.

A continuación vamos a modificar tanto las Acciones como los Targets de la plantilla.

Vemos que ya tenemos configuradas 3 acciones. Si vamos pinchando en cada una de ellas veremos que lo que hacen es estresar la CPU de la instancia primero al 80% durante 5 minutos, después al 90% durante 5 minutos y finalmente al 100% durante 5 minutos.

Vamos a modificar los valores de las tres acciones y vamos a decirle que se aplique la cara de CPU durante 3 minutos en vez de 5. Así podremos ver los resultados de esas acciones antes.

En cuanto al apartado de Target, vamos a asegurarnos que el experimento solo va a aplicar a **nuestra instancia**. Lo haremos o bien a través de una tag identificativa que le pongamos a nuestra instancia (este sería el momento de ir a EC2 y hacerlo), o bien seleccionando nuestra instancia de la lista por su nombre.

Para la ejecución del experimento seleccionaremos el rol *postgrado-backup*

Vamos a hacer que se guarden los logs de la ejecución del experimento en un bucket que ya existe en esta cuenta llamado : *super-public-bucket-upc* pero también le añadiremos un prefijo personal para identificar posteriormente nuestros logs.

## Ejecución del experimento

Una vez hayamos creado el experimento veremos toda la información sobre este. Incluso podremos exportar la plantilla del experimento si quisíeramos replicarlo en otro lado:

![](images/06.png)

Una vez hayamos confirmado que todo está correcto pulsaremos sobre **Start Experiment* y veremos como nuesro experimento empieza a ejecutar las acciones que le hemos definido y la primera acción pasará a estar en estado *running* después de unos minutos: 

![](images/07.png)

A partir de allí vamos a relajarnos un par de minutos porque la acción va a tardar más o menos ese tiempo en surtir efecto sobre nuestra instancia EC2.

Pasados un par de minutos vamos a ir a **EC2** y seleccionaremos nuestra instancia que debe estar corriendo aparentemente con normalidad. 

Vamos a pulsar la pestaña de *monitoring* y ver si realmente es así.

Importante: para facilitarnos un poco la vida y ver las métricas de la instancia con mayor precisión vamos a pulsar sobre **Manage Detailed Monitoring** y vamos a activar la monitorización detallada que, como el propio aviso nos va a indicar, nos va a permitir ver los gráficos con mayor tasa de refresco.

![](images/09.png)

También vamos a asegurarnos de que estamos viendo los gráficos en nuestra zona local (Local Timezone) y no en UTC. 

Unos minutos después veremos que el uso de CPU ha empezado a subir. FIS está haciendo su trabajo!

![](images/08.png)

Estas métricas salen con un poco de retraso así que hay que tener paciencia, pero unos minutos después debemos ver claramente como el uso de CPU de nuestra instancia incrementa.

Una vez que haya terminado al menos una de las acciones de nuestro Experimento, podremos ver que se han volcado los logs de la ejecución de la misma en el bucket que le hemos indicado.

Podemos ir viendo cómo avanza nuestro experimento y en qué fase está desde la pestaña de *Experiments* del AWS FIS.
