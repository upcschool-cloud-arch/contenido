# Lab 1: Infraestructura básica I

El objetivo de este primer laboratorio será familiarizarnos con la creación de la estructura básica de red para nuestros futuros entorno, así como tener una pequeña Landing Zone dónde lanzar los primeros recursos.

<img width="552" alt="image" src="https://user-images.githubusercontent.com/108825363/221699511-47c0a717-ea41-48c4-897f-988999fd7c25.png">


## Creación de una VPC

1. En el buscador de la consola, teclea VPC y clica sobre la primera opción
2. Click sobre el botón _Create VPC_
3. De momento solo queremos crear nuestra VPC, por lo que seleccionaremos VPC only y escribimos el nombre de nuestra VPC en _Name tag_: main_vpc_\*yourname\* 
4. Seleccionamos IPv4 CIDR manual input y tenancy _Default_. Introducimos el rango: 172.31.0.0/16
5. En _add tag_ escribimos la key:Lab, value:1 y clicamos sobre _Create VPC_:
6. Verificamos que se ha creado correctamente revisando el listado de VPCs.

Nota: verificad que aparece el nombre asignado. En caso contrario, podéis introducirlo manualmente a través del lápiz que aparece en el campo _Name_  <img src="https://lab1ester.s3.us-east-1.amazonaws.com/name_vpc.PNG?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEIj%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCWV1LXdlc3QtMyJHMEUCIEvmpAvJT6nlbUhlkI2totmUW%2FUNLj3kGpjTt5cfXGgvAiEAuUXJSZs7vv9oW0YccTY655Vwi9LvDCQLbbEKOCm4P7sqgwMIkf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwwNjc4MTEwMDUwNjAiDKICNAKIYXX3CIzYWCrXAjlmiy1PSeP2snwDuSE%2FIeLSPUAXi1OfvRRQWo5Uen2vP33jAiX4WlvvmB%2FGd%2BZagsOI3x%2Fm5S%2FhVi75lCGeg2LMyiaplu3CMcrsBWrqI2zQrb8uHAIYapbbONpLDRylvNsoTGQS78JXEwqK0qyPWtbd9ICLlvfBqRI9FPog%2BA%2F3682S39GNayhyz3MKIo1kxlvE3Kh9hPwLbx%2BVh7k3kyEsnjHiKF4ex2jIFdXX9u9Q3KPMrA%2BGvkJ2hUUglNxyrrdkDy8oWmyQjjl4W%2BIw7CaTz5kuJCprGZTe8hxc%2FC4In5SVhrLXUtqOzVdm%2FdgwM3UnrBsaNSwzMmMGakrF6rC%2B6faz8m%2FwQEqpNqDEoF7xUdsYRuPP2hKiLCvGA%2BpNrKoyBpQbxijgU9h003aLBkEKeF45AHuucAAWPHeEwa1JH9XmJtdF6%2BfXcrIEBszZ29OxzUzKw5IwjOmFqQY6hwIh7jVmB5wHGiTEc4uCuhOORmF5%2FJtHUrHOFYq6fGduVYAQ7o48qXEr3tiEScmAu7NBiNfpOpxOTH1N9eLoAWaYl%2FAvgaAeS6w2HycA9ovmfDdLv1LmYEL0anXBPj28s5CsSqQ5O9xXUtK6kQo%2BbsVygltZBUn5tc6gWW6WzFYnRF9RbgamTGBH1iw2iqcn15WmrNyD47qVoj%2Bx8Ll%2BzzGKmIe0w9pPMMmacuh6KC4ueZ%2BYTFjWs1QrbNuubzTvju8RZs1%2B8GeRvFiE6yfIUjT5GFsHzcMqWV%2FQXHD2WKp1oBI4mvFb9AIKtCer7rAHaJ0rCxQ%2FsrsjecVKameXXsGX6N2P4l7sRA%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20231007T155943Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIAQ7SOZ2KCMLH4V6EY%2F20231007%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=a231bcbdad4b96fce885b782f84f207e95d9c6e90e4c5d0e9258d23243ea8240)">

## Creación de las subnets

Crearemos 3 subnets de igual tamaño, una para cada AZ disponible en la región. Dado que partimos de una VPC /16 (2^16 =65.536), podremos dividir cómo mínimo en rangos /18. 

7. A través del menú de navegación de VPC (Izquierda), clicamos en _Subnets_
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

20. En el panel Your VPCs, clicamos sobre nuestra Main VPC.
21. En la pestaña _details_, podemos ver que nuestra VPC ya tiene por defecto, una route table principal. Si clicamos sobre el identificador, podemos ver el detalle.
22. Clicamos sobre la pestaña _Routes_ y vemos que tenemos la ruta local hacia nuestra VPC: 172.31.0.0/16. Las subnets que forman parte de esta VPC y no tienen una asociación explítica con otra route table, seguirán las routas de la principal (implícita).
23. Si clicamos sobre la pestaña _Subnets_, veremos que las subnets que hemos creado en los puntos anteriores se encuentras asociadas de forma implícita a esta route table (Implícita = _Subnets without explicit association_).

En este momento, **aún no se han establecido las rutas necesarias para poder acceder a internet**. Para ello, crearemos una Custom Route Table que asociaremos de **forma explícita** a la subnet pública (main_subnet_a).

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

## Crear una EC2 simple
Vamos a necesitar una instancia EC2 para verificar que nuestro entorno se ha creado correctamente. 

32. Nos vamos al panel EC2 y seleccionamos _Launch Instance_
33. Definiremos los siguientes parámetros:
* Name: lab1
* Desplegamos _Application and OS Images_ y seleccionamos Ubuntu. Veréis que por defecto, selecciona una AMI gratuita.
* Instance type: t2.micro
* Key Pair (Login), creamos un nuevo key pair que llamaremos lab1. Clicar sobre _Create new key pair_ .
  **IMPORTANTE**: Guardad bien este .pem ya que lo utilizaremos en otras EC2s más adelante.
* _Networkin Settings_, seleccionamos el botón _Edit_ y escogemos nuestra VPC _main_vpc_yourname y la subnet _main_subnet_a. Dejamos el valor "Enable" el desplegable _Auto assign public IP_ .
       	* Creamos un nuevo SG vacío y lo llamaremos lab1. Quitad todos los checks de las reglas sugeridas.
* Finalmente desplegamos _Advance Details_ y pegamos el siguiente código en _User Data_:
```bash
#!/bin/bash
# Use this for your user data (script from top to bottom)
sudo apt update
sudo apt install apache2
sudo echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
```
34. Dejamos el resto de campos tal como estan y clicamos sobre el botón _Launch instances_ .


## Chequear la salida a internet

Ahora que ya tenemos nuestro entorno montado, vamos a verificar que funciona correctamente:

35. En el buscador de la consola escribimos EC2 y clicamos
36. En buscador del dashboard de EC2 escribimos: lab1 y seleccionamos la instancia
37. Copiamos la IP Pública de esta ec2 (Public IPV4), que encontraremos en la pestaña _Details_
38. Desde vuestra terminal, tecleamos:
```bash
ping <ip_pública_ec2> 
curl http://<ip_publica_ec2>
```
39. ¿Qué resultado obtienes?

No podemos llegar a la EC2 con IP pública. ¿Cuál crees que es el movito?

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

## Verificamos la salida y entrada a internet
46. De nuevo desde el terminal, comprueba los resultados al hacer:
```bash
ping <Public_IP>
curl http://<Public_IP>
````
¿Qué resultado obtienes ahora? También puedes copiar el siguiente comando en el navegador
```bash
 http://<Public_IP>
 ```
 
47. Verificamos que podemos acceder a la instancia EC2 por SSH. Para ello, vamos a necesitar el fichero lab1.pem que hemos obtenido al crear la EC2.

--> Para acceder a la instancia desde nuestro terminal:

**Linux o Mac**

48. Desde el terminal, escribimos el siguiente comando si usamos Linux:
```bash
chmod 400 lab1.4.pem
```
Nota: en la ruta en la que tengamos guardado el .pem

```bash
ssh -i "lab1.pem" ubuntu@<Públic IP>
````

**Windows**

48.b Si utilizáis Windows, utilizad Putty para acceder a esta EC2. Podéis descargarlo en el siguiente enlace:
https://www.putty.org/

49. Dado que hemos descargado la key en .pem, deberemos convertirlo a .ppk con PuttyGen, que podréis descargar del enlace anterior.
50. Una vez convertido podréis acceder a través de Putty con la IP pública proporcionada por aws.

## Bonus track 

Hemos visto la importancia de que todos los recursos estén configurados correctamente para poder acceder desde internet a nuestros recursos internos. Si no podemos acceder a las EC2, lo primero que pensamos es que los SG no están abiertos para el protocolo que queremos utilizar, pero, ¿qué ocurre si los SG están correctamente definidos? 

En este apartado vamos a intentar hacer un poco de troubleshooting para determinar qué puede estar fallando.

51. Accedemos de nuevo a la consola de AWS y accedemos al VPC dashboard.
52. Generaremos una nueva VPC que llamarermos secondary_vpc y que eliminaremos al acabar el laboratorio.
    CIDR: 10.0.0.0/24
53. Dentro de esta VPC generaremos 3 subnets al igual que en el apartado anterior.
    secondary_subnet_a: 10.0.0.0/26, AZ: us-east-1a
    secondary_subnet_b: 10.0.0.64/26, AZ: us-east-1b
    secondary_subnet_c: 10.0.0.127/26, AZ:us-east-1c
    secondary_subnet_d: 10.0.0.192/26, AZ: us-east-1d

54. Crearemos también un nuevo internet gatewat que atacharemos a esta VPC secundaria.
55. Accedemos a la route table y generamos una route table custom (recordad que se recomienda no tocar la main route table). En esta nueva route table que llamaremos secondary_route_Table, añadiremos al ruta al Internet Gateway:
    Destination: 0.0.0.0/0
    Target: id_internet_gatewat
56. Finalmente crearemos una instancia ec2 en la subnet secondary_subnet_a
    Name: lab1_bonus_Track
    AMI: Amazon Linux
    Instance type: t2.micro
    Keypair, el mismo que utilizamos en los puntos anterior lab1.pem
    Network setting: seleccionamos la VPC secondary y la subnet secondary_subnet_a
    Security Group: generaremos unos nuevo y clicamos el check SSH y HTTP
57. Y clicamos launch instances
58. Una vez está generada esta nueva instancia, vamos a completar el SG con un regla que nos permita hacer ping desde cualquier lugar. Recordar que necesitaremos protocolo ICMP, desde 0.0.0.0/0
59. Finalizado este paso, hacemos ping desde nuestro terminal. ¿Qué resultado obtienes?

60. No podemos llegar por ping, y tampoco podríamos llegar por ssh. El motivo, tiene que ver con las asociaciones implicitas y explicitas de las route tables.
61. Accedemos de nuevo a las route tables y clicamos sobre la custom_secondary_route_table y a través de la pestaña _Subnet associations_ asociamos la subnet secondary_subnet_a a la custom route table.
62. Haz de nuevo ping y comprueba que funciona correctamente.

El motivo por el que no estaba funcionado el ping inicialmente es porqué nuestra custom route table no estaba explícitamos asociada a la subnet dónde se encuentra la EC2, y toma por defecto la route table de la VPC, que no tiene definida la salida a internet por el Internet Gateway.




