# LAB 2: Infraestructura básica II
EL objetivo de este laboratorio es preparar las subnets privadas para poder conectarse a internet en caso de que sea necesario

## Creación de Nat Gateway

1. En el panel de VPC, a la izquierda seleccionamos  Nat Gateway
2. Clicamos sobre el botón crear Nat Gateway
3. En el nombre del Nat Gateway, indicamos main_nat_gateway
4. Recordemos que el nat gateway siempre debe ir asoiciado a una subnet pública. En este caso, deberemos asociarlo a la main_subnet_a
5. Seleccionaremos conectividad pública y asignaremos una Elastic IP 
6. En Tags, añadimos Key: lab , Value: 2


## Ajustes de Route Tables
7. Agregaremos la routa hacia el nat-gateway en la route table principal. Desde el panel de VPC, seleccionamos "Route Tables"
8. Seleccionamos la Main_Route_Table asociada a nuestra VPC (main_vpc_<your_name>) y seleccionamos la pestaña Routes.
9. Clicamos sobre el botón _Edit Route Tables_ y añadimos:
	• Destination: ¿Cual debería ser? , Target: Nat Gateway <id_nat-gateway>
	
Ahora todas las subnets privadas están asociadas implicitamente a este Route Table con la ruta hacia el NAT gateway. Recordad que la subnet pública (main_subnet_a) tenía una asociación explícita a la Custom_Route_Table que habíamos definido en el lab1, dónde teníamos la ruta hacía internet a través del Internet Gateway.

10. Vamos a intentar dejar todo en la Main_Route_Table. En el dashboard de VPC, y selecciona la Main_Route_Table, que será la route table asociada a vuestra VPC main_vpc_yourname
11. Clicamos sobre la pestaña _Routes_ y añadimos la línea del Internet Gateway, definiendo el como destination: 0.0.0.0/0 y el Target: el ID del Internet Gateway creado en el lab 1.
12. ¿Cuál es el resultado?

El resultado será un error, ¿Sabríais decir por qué?

El motivo es que no podemos tener dos salidas a la misma dirección dentro de la misma Route Table.

13. Vamos a ver qué ocurre si dejamos únicamente el nat gateway. Volvemos al apartado de _Route_Tables y seleccionamos la Custom_main_route_table que es dónde tenemos definida nuestra salida a internet. 
14. Clicamos sobre subnet associations y en _Edit_subnet_associations_ y eliminamos la asociación explícita, quitando el check de la main_subnet_a.
15. Vamos a probar llegar desde internet hasta la EC2. Para ello haz ping a la nueva IP de instancia EC2 del lab1 (aseguraros de que está running). ¿Cuál es el resultado?

No podremos alcanzar nuestra EC2 desde internet porque no tenemos definido una ruta a internet desde el Internet Gateway, aunque tengamos el security group abierto.

16. Accede a través de la shell de la instancia a la EC2. Para ello, clica en la consola, arriba a la derecha sobre el botón _Connect_
17. El resultado es que tampoco podemos conectarnos. Asocia de nuevo **explícitamente** la Custom_main_route_Table a la main_subnet_a

Tened en cuenta que esta es la única manera de poder trabajar subnets públicas y privadas dentro de la misma VPC. Si nuestra VPC fuera enteramente pública, podríamos en la Main Route Table, dejar una ruta a internet a través de Internet Gateway sin necesidad de realizar una asociación explícita. Aún así, se aconseja no tocar la main route table que viene por defecto en la VPC.
		
## Creación EC2 en subnet privada

18. Crearemos una EC2 de características muy similares a lab1 pero sin públic IP
19. Desde el dashboard de EC2, creamos esta EC2:

* Name: lab2
* Desplegamos Application and OS Images y seleccionamos Amazon Linux
* Instance type: t2.micro
* Key Pair: usamos el mismo key pair del lab1
* Networkin Settings, seleccionamos el botón _Edit_ y escogemos nuestra VPC _main_vpc_yourname y la subnet _main_subnet_b. 
* Deshabilitamos _Auto-assign public IP_
	* Creamos un nuevo SG vacío que llamaremos lab2 y habilitamos el inboud para conexión ssh desde la IP privada de la ec2 lab1 (recordad que la EC2 lab1 será nuestra instancia de salto).
* Finalmente desplegamos Advance Details y pegamos el siguiente código:
```bash
#!/bin/bash
# Use this for your user data (script from top to bottom)
sudo apt update
sudo apt install apache2
sudo echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
```
	

## Chequeo del Nat Gateway

Comprobaremos el correcto funcionamiento del nat gateway, saliendo a internet a través de una instancia ec2 ubicada en una de nuestras subnets privadas. Para ello, necesitaremos conectarnos a una instancia de salto con ip pública.

20. En el dashboard de EC2, buscamos la instancia lab1 y la iniciamos a través del botón _Instance State_--> _Start Instances_ en caso de estar parada.
21. Copiamos la IP pública que se muestra en la pestaña _Details_
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

En esta segunda parte del lab, vamos a establecer una conexión por peering entre nuestras VPCs

29. A través de la consola, accede al dashboard de VPCs. En las opciones de la izquierda, encontraréis un apartado llamado _Peering Connections_ .
30. Clicad sobre el botón _Create peering connection_
31. Nombraremos a este peering my_first_peering_connection y seleccionaremos nuestra main_vpc_yourname como VPC requester
32. Seleccionamos _my account_ y _This region_, en VPC accepter selecciona la VPC default y clicad sobre el botón _Create peering connection_.
33. ¿Qué ha ocurrido?

Recordad que la vpc default es 172.31.0.0/16, al igual que nuestra main VPC, con lo que estamos teniendo overlaping y AWS no nos permitirá hacer peering entre estas dos vpcs para evitar conflictos a la hora de comunicarse entre ellas.

34. Seleccionad como VPC Accepter la secondary_vpc (creada en el _Bonus track_ del lab anterior). 
35. Añadimos el tag key: lab y value: 2 y clicamos sobre el boton _create peering connection_
36. Como owners de la secondary VPC, nos llegará una notificación de aceptación del peering. La aceptamos y ya tendremos el peering creado.
37. Si queremos establecer comunicación, deberemos crear las rutas correspondientes tanto en la vpc orígen, como destino.
38. Accedemos al listado de route tables y clicamos sobre la main route table de la main_vpc_your_name. Agregamos una nueva ruta con destino: 10.0.0.0/24 a través del target peering_id.
39. En la main route table de la secondary_vpc agregamos una nueva ruta con destino 172.31.0.0/16 a través del target peering_id.

Vamos a verificar que la comunicación entre instancias de estas VPCS funciona correctamente.

40. En la VPC secondary, creamos una EC2 llamada lab2_secondary, en la que **NO** tendremos IP pública.
* Name: lab2_secondary
* Desplegamos Application and OS Images y seleccionamos ubuntu
* Instance type: t2.micro
* Key Pair: usamos el mismo key pair del lab1
* Networkin Settings, seleccionamos el botón _Edit_ y escogemos nuestra VPC secondary_vpc y la subnet _secondary_b 
* Deshabilitamos _Auto-assign public IP_
	* Creamos un nuevo SG vacío que llamaremos lab2.2 y habilitamos el inboud para conexión por ICMP desde la IP privada de la ec2 lab2.

41. Un vez creada esta instancia, podemos hacer ping desde la ec2 lab2 hacia la ip privada de lab2_secondary

Tened en cuenta que si no hubieramos establecido el peering no sería posible comunicar dos instancias con IPd privadas en diferentes VPCs.

## Delete Nat Gateway

Para evitar un exceso de gastos, vamos a eliminar el NAT Gateway hasta que volvamos a necesitarlo.

42. A través del VPC dashboard, accedemos al apartado NAT Gateways y clicamos en el único que tenemos creado.
43. Clicamos sobre el botón _Actions_ y seleccionamos Delete NAT Gateway. Escribimos delete en el cuadro y finalizamos.
