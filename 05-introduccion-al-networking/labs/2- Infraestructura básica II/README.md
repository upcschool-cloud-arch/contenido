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

El resultado será un errror, ¿Sabríais decir por qué?

El motivo es que no podemos tener dos salidas a la misma dirección dentro de la misma Route Table.

13. Vamos a ver qué ocurre si dejamos únicamente el nat gateway. Volvemos al apartado de _Route_Tables y seleccionamos la Custom_main_route_table que es dónde tenemos definida nuestra salida a internet. 
14. Clicamos sobre subnet associations y en _Edit_subnet_associations_ y eliminamos la asociación explícita, quitando el check de la main_subnet_a.
15. Vamos a probar llegar desde internet hasta la EC2. Para ello haz ping a la nueva IP de instancia EC2 del lab1 (aseguraros de que está running). ¿Cuál es el resultado?

No podremos alcanzar nuestra EC2 desde internet porque no tenemos definido una ruta a internet desde el Internet Gateway, aunque tengamos el security group abierto. Sin embargo, si quisieramos acceder desde nuestra EC2 a internet sí que deberíamos poder conectar. 

16. Accede a través de la shell de la instancia a la EC2. Para ello, clica en la consola, arriba a la derecha sobre el botón _Connect_
17. 

		
## Creación EC2 en subnet privada

14. Crearemos una EC2 de características muy similares a lab1 pero sin públic IP
15. Desde el dashboard de EC2, creamos esta EC2:

* Name: lab2
* Desplegamos Application and OS Images y seleccionamos Amazon Linux
* Instance type: t2.micro
* Key Pair: usamos el mismo key pair del lab1
* Networkin Settings, seleccionamos el botón _Edit_ y escogemos nuestra VPC _main_vpc_yourname y la subnet _main_subnet_b. 
* Deshabilitamos _Auto-assign public IP_
	* Creamos un nuevo SG vacío y habilitamos el inboud para conexión ssh
* Finalmente desplegamos Advance Details y pegamos el siguiente código:
```bash
#!/bin/bash
# Use this for your user data (script from top to bottom)
sudo apt update
sudo apt install apache2
sudo echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
```
	

## Chequeo del Nat Gateway

Comprabaremos el correcto funcionamiento del nat gateway, saliendo a internet a través de una instancia ec2 ubicada en una de nuestras subnets privadas. Para ello, necesitaremos conectarnos a una instancia de salto con ip pública.

16. En el dashboard de EC2, buscamos la instancia lab y la iniciamos a través del botón _Instance State_--> _Start Instances_ en caso de estar parada.
17. Copiamos la IP pública que se muestra en la pestaña _Details_
18. Accedemos por ssh a la instancia lab1. Abrimos el terminal y utilizamos el siguiente comando: 
```bash
ssh -i "lab1.pem" ec2-user@<ip publica>
````
15. Una vez dentro de la instancia de salto, podemos acceder a la instancia privada _lab2_, a través del mismo comando visto en el punto 18: 

 ```bash
ssh -i "lab.pem1" ec2-user@<ip_privada>
```

Un vez dentro de una ec2 ubicada en una subnet privada y sin IP pública, podemos chequear si el nat gateway está funcionado:

16. Hacemos ping
```bash
 ping 8.8.8.8 // Google
 ```
17. Si lanzamos un _traceroute_, podemos ver el camino que sigue nuestro paquete IP y si realmente está pasadando por el Nat Gateway
	
