# LAB 2: Infraestructura básica II
EL objetivo de este laboratorio es preparar las subnets privadas para poder conectarse a internet en caso de que sea necesario

## Creación de una Elasitc IP
Antes de comenzar, vamos a ver cómo crear una Elastic IP, que utilizaremos posteriormente para nuestro Nat Gateway.

1. En el panel de VPC, encontraremos la opción Elastic IP, en la lista de servicios de la izquierda de la pantalla. Clicamos sobre _Elastic IP_
2. Clicamos sobre el botón _Allocate Elastic IP adress_
3. Dejaremos por el Networ Border Group que aparece por defecto y en los tags añadiremos:
   * Key: Name, Value: my_first_EIP
   * Key: lab, Value: 2
   Y crearemos la EIP con el botón _Allocate_
   
## Creación de Nat Gateway

4. En el panel de VPC, a la izquierda seleccionamos  Nat Gateway
5. Clicamos sobre el botón _Create Nat Gateway_
6. En el nombre del Nat Gateway, indicamos main_nat_gateway
7. Recordemos que el **nat gateway siempre debe ir asociado a una subnet pública**. En este caso, deberemos asociarlo a la main_subnet_a
8. Seleccionaremos conectividad pública y para la Elastic IP, seleccionaremos la que hemos creado en el primer apartado.
9. En Tags, añadimos Key: lab , Value: 2


## Ajustes de Route Tables
10. Agregaremos la routa hacia el nat-gateway en la route table principal. Desde el panel de VPC, seleccionamos "Route Tables"
11. Seleccionamos la Main_Route_Table asociada a nuestra VPC (main_vpc_<your_name>) y seleccionamos la pestaña Routes.
12. Clicamos sobre el botón _Edit Route Tables_ y añadimos:
	• Destination: ¿Cual debería ser? , Target: Nat Gateway <id_nat-gateway>
	
Con la configuración actua, todas las subnets privadas (main_subnet_b y main_subnet_C) de nuestra VPC, están asociadas implicitamente a Main Route Table (venía por defecto en la VPC) y con la ruta hacia el NAT gateway. Recordad que la subnet pública (main_subnet_a) tenía una asociación explícita a la Custom_Route_Table que habíamos definido en el lab1, dónde teníamos la ruta hacía internet a través del Internet Gateway.

13. Recordad, que una de las best practices, es no tocar la route table que viene por defecto en la VPC. Por ello, vamos a intentar dejar todo en la Custom_Route_Table. En el dashboard de VPC, y selecciona la Main_Route_Table y eliminiamos la ruta al nat gateway.
14. Nuevamente, volvemos al dashboard de las route table y clicamos sobre la Custom_route_table. Clicamos sobre la pestaña _Routes_ y añadimos la línea del nat gateway, definiendo el como destination: 0.0.0.0/0 y el Target: el ID del NAT Gateway creado
15. ¿Cuál es el resultado?

El resultado será un error, ¿Sabríais decir por qué?

El motivo es que no podemos tener dos salidas a la misma dirección dentro de la misma Route Table.

A partir de aquí podemos aplicar dos estrategias:
* Añadir de nuevo la ruta al nat gateway en la Main Route Table.
* Crear una segunda Custom2_main_route_table con la ruta al nat gateway y realizar una asociación exo¡plícita de las 2 subnets privadas (main_subnet_b y main_subnet_c) a esta segunda custom route table.

Vamos a optar por la segunda opción:

16. En el dashboard de las route table, creamos una nueva llamada Custom2_Main_Route_Table y añadimos la ruta a nuestro nat gateway.
17. Clicamos sobre subnet associations y en _Edit_subnet_associations_ y en la sección Explicit subnet associations, seleccionaremos las main subnets b y c.
   
Tened en cuenta que esta es la única manera de poder trabajar subnets públicas y privadas dentro de la misma VPC. Si nuestra VPC fuera enteramente pública, podríamos en la Main Route Table, dejar una ruta a internet a través de Internet Gateway sin necesidad de realizar una asociación explícita. Aún así, se aconseja no tocar la main route table que viene por defecto en la VPC.
		
## Creación EC2 en subnet privada

Para verificar que el nat gateway está correctamente configurado, vamos a crear una EC2 en la subnet privada y vamos a intentar acceder a internet desde ella:

18. Crearemos una EC2 de características muy similares a lab1 pero sin públic IP
19. Desde el dashboard de EC2, creamos esta EC2:

* Name: lab2
* Desplegamos Application and OS Images y seleccionamos Amazon Linux
* Instance type: t2.micro
* Key Pair: usamos el mismo key pair del lab1
* Networkin Settings, seleccionamos el botón _Edit_ y escogemos nuestra VPC _main_vpc_yourname y la subnet _main_subnet_b. 
* Deshabilitamos _Auto-assign public IP_
	* Creamos un nuevo SG vacío que llamaremos lab2 y habilitamos el inboud para conexión ssh desde la IP privada de la  EC2 lab1 (recordad que la EC2 lab1 será nuestra instancia de salto).

## Chequeo del Nat Gateway

Comprobaremos el correcto funcionamiento del nat gateway, saliendo a internet a través de una instancia ec2 ubicada en una de nuestras subnets privadas. Para ello, necesitaremos conectarnos a una instancia de salto con ip pública.

20. En el dashboard de EC2, buscamos la instancia lab1 y la iniciamos a través del botón _Instance State_--> _Start Instances_ en caso de estar parada.
21. Copiamos la IP pública que se muestra en la pestaña _Details_ (esta IP habrá cambiado respecto a la que teníamos el lab1 por haber parado la EC2, recordad lo que hemos hablado en la sesión sobre las ENIs).
22. Accedemos por ssh a la instancia lab1. Abrimos el terminal y utilizamos el siguiente comando si trabajamos con Linux:
**Recordad, si no lo hicisteis en el lab anterior, lanzar el siguiente comando antes de hacer el ssh:
```bash
chmod 400 lab1.pem
```

```bash
ssh -i "lab1.pem" ec2-user@<ip publica>
````
Windows:
A través de Putty

23. Una vez dentro de la instancia de salto, podemos acceder a la instancia privada _lab2_. Pero antes, tendremos que realizar algunas configuraciones previas.
24. En primer lugar, tendremos que crear un fichero copiando el text de lab1.pem. y guardándolo con este mismo nombre. Recordad poneros en root para evitar problemas de permisos.
25. Un vez tenemos el fichero creado, cambiaremos los permisos:
```bash
chmod 400 lab1.pem
```

26. Desde el mismo directorio dónde hemos creado este fichero .pem accedemos a la instancia con el siguiente comando:
 ```bash
ssh -i "lab1.pem" ec2-user@<ip_privada_lab2>
```

Un vez dentro de una ec2 ubicada en una subnet privada y sin IP pública, podemos chequear si el nat gateway está funcionado:

27. Hacemos ping
```bash
 ping 8.8.8.8 // Google
 ```
28. Si lanzamos un _traceroute 8.8.8.8_, podemos ver el camino que sigue nuestro paquete IP y si realmente está pasando por el Nat Gateway. Podéis verificar la IP (privada) de vuestro Nat Gateway en la consola de AWS.

## Peering Connection

Si queremos comunicarnos de forma privada con instancias que están fuera de nuestra VPC, necesitaremos establecer una comunicación privada entre VPCs. Tal como hemos visto en la sesión, tenemos varias maneras de hacerlo, pero para este lab, vamos a optar por la opción del realizar un peering entre VPCs.

29. A través de la consola, accede al dashboard de VPCs. En las opciones de la izquierda, encontraréis un apartado llamado _Peering Connections_ .
30. Clicad sobre el botón _Create peering connection_
31. Nombraremos a este peering my_first_peering_connection y seleccionaremos nuestra main_vpc_yourname como VPC requester
32. Seleccionamos _my account_ y _This region_, en VPC accepter selecciona la VPC default y clicad sobre el botón _Create peering connection_.
33. ¿Qué ha ocurrido?

Recordad que la vpc default es 172.31.0.0/16, al igual que nuestra main VPC, con lo que estamos teniendo overlaping. AWS no nos permitirá hacer peering entre estas dos vpcs para evitar conflictos a la hora de comunicarse entre ellas.

34. Seleccionad como VPC Accepter la secondary_vpc (creada en el _Bonus track_ del lab anterior). Si no llegastéis a hacer el bonus track, cread una nueva vpc con el CIDR 10.0.0.0/24.
35. Añadimos el tag key: lab y value: 2 y clicamos sobre el boton _create peering connection_
36. Como owners de la secondary VPC, nos llegará una notificación de aceptación del peering. La aceptamos y ya tendremos el peering creado. En cuanto creeis el peering, veréis en el botón _Actions_ en la esquina superior derecha de la consola. Clicais sobre _Accept request_.
37. Si queremos establecer comunicación, deberemos crear las rutas correspondientes tanto en la vpc orígen, como destino.
38. Accedemos al listado de route tables y clicamos sobre la Custom_Main_Route_Table table de la main_vpc_your_name. Agregamos una nueva ruta con destino: 10.0.0.0/24 a través del target peering_id.
39. En la main route table de la secondary_vpc agregamos una nueva ruta con destino 172.31.0.0/16 a través del target peering_id. Si no has hecho el ejercicio del bonus track, coge la default route table de la VPC secundario y añadele el tag Main_route_table_secondary para que la puedas identificar fácilmente.

Vamos a verificar que la comunicación entre instancias de estas VPCS funciona correctamente.

40. En la VPC secondary, creamos una EC2 llamada lab2_secondary, en la que **NO** tendremos IP pública.
* Name: lab2_secondary
* Desplegamos Application and OS Images y seleccionamos ubuntu
* Instance type: t2.micro
* Key Pair: usamos el mismo key pair del lab1
* Networkin Settings, seleccionamos el botón _Edit_ y escogemos nuestra VPC secondary_vpc y la subnet _secondary_b. Si no hiciste el bonus track, tendrás que crear una subnet en la vpc secundaria. La CDIR de esta subnet debería ser: 10.0.0.64/26
* Deshabilitamos _Auto-assign public IP_
	* Creamos un nuevo SG vacío que llamaremos lab2.2 y habilitamos el inboud para conexión por ICMP desde la IP privada de la ec2 lab2.

41. Un vez creada esta instancia, podemos hacer ping desde la ec2 lab2 hacia la ip privada de lab2_secondary.
42. Verificad que podéis hacer el ping.

Tened en cuenta que si no hubieramos establecido el peering no sería posible comunicar dos instancias con IP privadas en diferentes VPCs.

## Delete Nat Gateway

Para evitar un exceso de gastos, vamos a eliminar el NAT Gateway hasta que volvamos a necesitarlo.

43. A través del VPC dashboard, accedemos al apartado NAT Gateways y clicamos en el único que tenemos creado.
44. Clicamos sobre el botón _Actions_ y seleccionamos Delete NAT Gateway. Escribimos delete en el cuadro y finalizamos.
