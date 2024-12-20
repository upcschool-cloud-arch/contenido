# Lab 1: Infraestructura básica I

El objetivo de este primer laboratorio será familiarizarnos con la creación de la estructura básica de red para nuestros futuros entorno, así como tener una pequeña Landing Zone dónde lanzar los primeros recursos.

<img width="552" alt="image" src="https://user-images.githubusercontent.com/108825363/221699511-47c0a717-ea41-48c4-897f-988999fd7c25.png">


## Creación de una VPC

1. En el buscador de la consola, teclea VPC y clica sobre la primera opción
2. Click sobre el botón _Create VPC_
3. De momento solo queremos crear nuestra VPC, por lo que seleccionaremos VPC only y escribimos el nombre de nuestra VPC en _Name tag_: main_vpc_\*yourname\* 
4. Seleccionamos IPv4 CIDR manual input y tenancy _Default_. Introducimos el rango: 172.31.0.0/16
5. En _add tag_ escribimos la key:Lab, value:1 y clicamos sobre _Create VPC_:
6. Verificamos que se ha creado correctamente revisando el listado de VPCs. Es posible que tengáis dos VPCs con el mismo CIDR. Una de ellas es la que viene por defecto en la propia cuenta de academy. Podéis diferenciar la que viene por defecto respecto a la que habéis creado o bien por el nombre (tag añadido en el punto 5) o bien identificando en la tabla de las VPCs, la columna _Default VPC_. La que se encuentre definida con un YES en esta columna, será LA que viene por defecto en el entorno y NO LA QUE ACABAIS CREAR.

Nota: verificad que aparece el nombre asignado. En caso contrario, podéis introducirlo manualmente a través del lápiz que aparece cuando pasamos por encima del campo _Name_

## Creación de las subnets

Crearemos 3 subnets de igual tamaño, una para cada AZ disponible en la región. Dado que partimos de una VPC /16 (2^16 =65.536), podremos dividir cómo mínimo en rangos /18. 

7. A través del menú de navegación de VPC (Izquierda), clicamos en _Subnets_ . Veréis que aquí también nos encontramos algunas subnets ya creadas. Por el momento, no haremos uso de ellas.
8. Clicamos sobre el botón, _Create subnet_. En el desplegable, seleccionamos la VPC creada en el apartado anterior: main_vpc_\*yourname\*
9. AWS nos permite crear de una vez tantas subnets como necesitemos, siempre que no excedamos el rango marcado por la VPC. Escribimos en el cuadro
_Subnet Name_: main_subnet_a y seleccionaremos la AZ correspondiente (región-1a)
10. Definimos el rango: 172.31.0.0/24 y clicamos sobre _Add New Subnet_
11. Repetimos la operación 2 veces más para las otras 2 Azs
	* 11.1 172.31.1.0/24 main_subnet_b para la AZ correspondiente (region-1b)
	* 11.2 172.31.2.0/24 main_subnet_c para la AZ correspondiente (región-1c)
12. Clicamos sobre _Create subnet_
	
Nuestra subnet pública será la main_subnet_a, que en este momento cuenta con un rango privado de IPs. Para darle características de subnet pública, vamos a autoasignar IPs públicas.

13. En el dashboard de VPCs, clicamos sobre la Subnets y seleccionamos _main_subnet_a_ 
14. Clicamos sobre el botón _Actions_ (lo encontraréis en la esquina superior a la derecha) --> _Edit Subnet Settings_
15. Marcamos la opción _Enable auto-assign public IPV4 adress_ y guardamos

## Creación de Internet Gateway

16. Retomamos el panel de VPC y seleccionamos _Internet Gateway_ (menú de la izquierda)
17. Clicamos sobre el botón _Create internet gateway_ y escribimos: main_internet_gateway y creamos.

En este punto veremos que ya tenemos creado nuestro Internet Gateway, pero no se encuentra atachado a ninguna VPC, por lo que la comunicación hacia internet aún no podrá establecerse.

18. En la esquina superior derecha, clicamos sobre _Attach to a VPC_ y seleccionamos nuestra main_vpc_\*yourname\*
19. Verificamos que aparece como Attached en el listado de Internet Gateway.


## Creación de la route table
Una vez creada la puerta de entrada y salida a internet, necesitaremos definir las rutas, para que nuestros "paquetes de datos" puedan llegar al destino.

20. En el panel Your VPCs, clicamos sobre nuestra Main VPC.
21. Si navegamos por las diferentes pestañas, concretamente sobre _resource map_, podemos ver que la relación entre los diferentes elementos de nuestra red. En este caso, vemos que nuestra VPC tiene 3 subnets, que a su vez están relacionadas con una route table, que es la route table default, que se crea por defecto cuando hemos creado nuestra VPC y que tenemos asociada de forma implícita a todas las subnets dentro de la VPC. Si clicamos sobre la flechita a la derecha del identificador, podemos ver el detalle.
22. Clicamos sobre la pestaña _Routes_ y vemos que tenemos la ruta local hacia nuestra VPC: 172.31.0.0/16. Las subnets que forman parte de esta VPC y no tienen una asociación explítica con otra route table, seguirán las routas de la principal (implícita).
23. Si clicamos sobre la pestaña _Subnets associations_, veremos que las subnets que hemos creado en los puntos anteriores se encuentras asociadas de forma implícita a esta route table (Implícita = _Subnets without explicit association_).

En este momento, **aún no se han establecido las rutas necesarias para poder acceder a internet**. Para ello, crearemos una Custom Route Table que asociaremos de **forma explícita** a la subnet pública (main_subnet_a). EL objetivo es mantener la route table "limpia".

24. Crearemos una route table custom asociada a nuestra VPC principal. En el dashboard general de VPC, seleccionamos _Route Table_ (menú izquierda, debajo de Subnets).
25. Clicamos sobre el botón _Create Route Table_ (arriba al derecha)
26. El nombre de route table custom será: Custom_Main_Route_Table y añadiremos la etiqueta: Key: Lab, Value: 1. Seleccionamos la VPC main_vpc_\*yourname\*
27. En el menú Route Tables, clicamos sobre la route table que acabamos de crear y seleccionamos la pestaña Routes
28. Añadimos la rutas necesarias para poder salir a internet. Clicamos sobre _Edit Routes_ y añadimos:
* Destination: 0.0.0.0/0  Target: id del Internet Gatewat creado (main_internet_gateway)
* La destinación local debería aparecer por defecto.
** Destination: 172.31.0.0/16 y target: local
29. A continuación, tendremos que realizar la **asociación explícita** para que la subnet utilice nuestro custom route table en lugar de la route table generada por defecto en la VPC.
30. En el panel _Route Tables_ seleccionamos Custom_main_route_table y clicamos a la pestaña _Subnet associations_
31. Sobre el apartado _Explicit subnet associations_, clicamos en _Edit subnet associations_ y seleccionamos nuestra subnet pública, main_subnet_a y clicamos sobre _Save associations_.

Nota: **es muy importante que realices esta asociaión explícita** para permitir la salida a internet. En caso de no hacer, los paquetes tomaran la route table por defecto de la VPC que NO tiene indicado el camino a hacia el Internet Gateway.

## Crear una EC2 simple
Vamos a necesitar una instancia EC2 para verificar que nuestro entorno se ha creado correctamente. 

32. Nos vamos al panel EC2 y seleccionamos _Launch Instance_
33. Definiremos los siguientes parámetros:
* Name: lab1
* Desplegamos _Application and OS Images_ y seleccionamos Amazon Linux. Veréis que por defecto, selecciona una AMI gratuita.
* Instance type: t2.micro
* Key Pair (Login), creamos un nuevo key pair que llamaremos lab1. Clicar sobre _Create new key pair_ .
  **IMPORTANTE**: Guardad bien este .pem ya que lo utilizaremos en otras EC2s más adelante.
* _Networkin Settings_, seleccionamos el botón _Edit_ y escogemos nuestra VPC _main_vpc_yourname y la subnet _main_subnet_a. Dejamos el valor "Enable" el desplegable _Auto assign public IP_ .
       	* Creamos un nuevo SG vacío y lo llamaremos lab1. Quitad todos los checks de las reglas sugeridas.
34. Dejamos el resto de campos tal como estan y clicamos sobre el botón _Launch instances_ .


## Chequear la salida a internet

Ahora que ya tenemos nuestro entorno montado, vamos a verificar que funciona correctamente:

35. En el buscador de la consola escribimos EC2 y clicamos
36. En buscador del dashboard de EC2 escribimos: lab1 y seleccionamos la instancia
37. Copiamos la IP Pública de esta EC2 (Public IPV4), que encontraremos en la pestaña _Details_
38. Desde vuestra terminal, tecleamos:
```bash
ping <ip_pública_ec2> 
curl http://<ip_publica_ec2>
```
39. ¿Qué resultado obtienes?

No podemos llegar a la EC2 con IP pública. ¿Cuál crees que es el motivo?

A pesar de haber definido las route table, **recordad que no hemos añadido reglas al Security Group que acabamos de crear**. Como hemos visto en la sesión, los SG por defecto deniega el inbound a los recursos, que en este caso es nuestra EC2.

## Creamos los security groups
40. Volvemos al panel de las EC2 y clicamos sobre nuestra instancia lab1.
41. Clicamos sobre la pestaña Security y a continuación sobre el id del SG
42. Sobre la pestaña Inbound, verificamos que no hay SG roules creadas
43. Clicamos sobre el botón _Edit Inbound roules_ y añadimos las reglas que nos permitan:
	* Acceder por SSH. Recordad que el orígen debería estar limitado a una IP o rango de IPs (en este caso sería vuestro laptop)
	* Puerto 80 y puerto 443. ¿Cual debería ser el orígen?
	* Hacer ping hacia a nuestra EC2.

44. Guardamos las nuevas reglas desde el botón _Save rules_ .
45. Comprobar que las reglas outbound permiten todo el tráfico hacia fuera. Clicamos sobre la pestaña Outbound rules y verificamos que en Type tenemos "All traffic".

## Verificar el acceso por ssh 

Vamos a verificar que hemos definido correctamente los security groups y para ello, vamos a acceder a nuestra EC2 para instalar un web server y así comprobar también al acceso desde internet a nuestro servicio web.

46. Para acceder a la instancia EC2 por SSH, vamos a necesitar el fichero lab1.pem que hemos obtenido al crear la EC2.

**Linux o Mac**

47a. Desde el terminal, escribimos el siguiente comando si usamos Linux:
```bash
chmod 400 lab1.pem
```
Nota: en la ruta en la que tengamos guardado el .pem

```bash
ssh -i "lab1.pem" ec2-user@<Públic IP>
````

**Windows**

47b. Si utilizáis Windows, utilizad Putty para acceder a esta EC2. Podéis descargarlo en el siguiente enlace:
https://www.putty.org/
Dado que hemos descargado la key en .pem, deberemos convertirlo a .ppk con PuttyGen, que podréis descargar del enlace anterior.
Una vez convertido podréis acceder a través de Putty con la IP pública proporcionada por aws.

48. Una vez dentro de la EC2, instalamos apache:

```bash
sudo dnf update -y 
sudo dnf list | grep httpd 
sudo dnf install -y httpd.x86_64 
sudo systemctl start httpd.service 
sudo systemctl status httpd.service 
sudo systemctl enable httpd.service
```
49. Crearemos un fichero en la siguiente path:

```bash
sudo nano /var/www/html/index.html
```
50. Enganchamos el siguiente texto y guardamos el fichero

```bash
<!DOCTYPE html> 
<html> <body> <h1>Hello World !!</h1> <p>Welcome to introducción al networking lab1</p> </body> </html
```

51. Para asegurarnos que el apache ha cogido los cambios, realizamos un restart del servicio:
```bash
sudo systemctl restart httpd.service
```
 
## Verificamos la salida y entrada a internet

52. De nuevo desde el terminal, comprueba los resultados al hacer:
```bash
ping <Public_IP>
curl http://<Public_IP>
````
¿Qué resultado obtienes ahora? También puedes copiar el siguiente comando en el navegador
```bash
 http://<Public_IP>
 ```

Nota: **Recuerda siempre parar las instancias para optimizar los créditos de los labs**. Para ello, selecciona la EC2 que quieres parar. A la derecha encontrarás el botón _Instance State_, clica sobre él y selecciona la opción _Stop instance_.

## Bonus track 

Hemos visto la importancia de que todos los recursos estén configurados correctamente para poder acceder desde internet a nuestros recursos internos. Si no podemos acceder a las EC2, lo primero que pensamos es que los SG no están abiertos para el protocolo que queremos utilizar, pero, ¿qué ocurre si los SG están correctamente definidos? 

En este apartado vamos a intentar hacer un poco de troubleshooting para determinar qué puede estar fallando.

53. Accedemos de nuevo a la consola de AWS y accedemos al VPC dashboard.
54. Generaremos una nueva VPC que llamarermos secondary_vpc.
    CIDR: 10.0.0.0/24
55. Dentro de esta VPC generaremos 4 subnets:
* secondary_subnet_a: 10.0.0.0/26, AZ: us-east-1a
* secondary_subnet_b: 10.0.0.64/26, AZ: us-east-1b
* secondary_subnet_c: 10.0.0.128/26, AZ:us-east-1c
* secondary_subnet_d: 10.0.0.192/26, AZ: us-east-1d

56. Crearemos también un nuevo internet gateway que atacharemos a esta VPC secundaria, secondary_internet_gateway.
57. Accedemos a la route table y generamos una route table custom (recordad que se recomienda no tocar la main route table). En esta nueva route table que llamaremos custom_secondary_route_table, añadiremos la ruta al Internet Gateway:
* Destination: 0.0.0.0/0
* Target: (secondary_internet_gateway)
58. Finalmente crearemos una instancia EC2 en la subnet secondary_subnet_a
* Name: lab1_bonus_track
* AMI: Amazon Linux
* Instance type: t2.micro
* Keypair: el mismo que utilizamos en los puntos anteriores, lab1.pem
* Network settings: seleccionamos la VPC secondary_vpc y la subnet secondary_subnet_a
* Security Group: generaremos uno nuevo y clicamos el check SSH y HTTP
57. Y clicamos launch instances
58. Una vez está generada esta nueva instancia, vamos a completar el SG con un regla que nos permita hacer ping desde cualquier lugar. Recordad que necesitaremos protocolo ICMP, desde 0.0.0.0/0
59. Finalizado este paso, hacemos ping desde nuestro terminal. ¿Qué resultado obtienes?

60. No podemos llegar por ping, y tampoco podríamos llegar por ssh. El motivo tiene que ver con las asociaciones implícitas y explícitas de las route tables.
61. Accedemos de nuevo a las route tables y clicamos sobre la custom_secondary_route_table y a través de la pestaña _Subnet associations_ asociamos la subnet secondary_subnet_a a la custom route table.
62. Haz de nuevo ping y comprueba que funciona correctamente.

El motivo por el que no estaba funcionado el ping inicialmente, es porque nuestra custom route table no estaba explícitamente asociada a la subnet donde se encuentra la EC2, y toma por defecto la route table de la VPC, que no tiene definida la salida a internet por el Internet Gateway.




