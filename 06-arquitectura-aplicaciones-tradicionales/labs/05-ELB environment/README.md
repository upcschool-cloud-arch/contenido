# LAB 5: ARQUITECTURA TRADICIONAL

En este lab, crearemos una pequeña arquitectura basada el un ELB que nos permitirá distribuir las peticiones entre las instancias que formarán el TG.


## Creación de Network Load Balancer

En primer lugar, vamos a familiarizarnos con el concepto del Network Load Balancer. Antes de lanzar el NLB, procederemos a crear el target group al cual asociaremos. Este Target group va a consistir en un conjunto de 3 EC2 de iguales características

1. Levantaremos nuestra EC2 Workstation
2. Un vez levantada nuestra EC2, accederemos al Terminal a través del enlace: https://yourname-workstation.aprender.cloud/vscode
3. Crearemos una carpeta llamada lab5:
```bash
mkdir lab5
```
4. Crearemos nuestro fichero _main.tf_ dónde incluiremos el siguiente código, que nos levantará 3 instancias idénticas dentro de la subnet pública _main_subnet_a
```bash
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-02f3f602d23f1659d"
  instance_type          = "t2.micro"
  key_name               = "lab1"
  user_data = <<-EOF
	#!/bin/bash
	yum update -y
	yum install -y httpd
	systemctl start httpd
	systemctl enable httpd
	echo "<h1>Hello I'm  $(hostname -f) ! </h1>" > /var/www/html/index.html
	EOF
  monitoring             = true
  vpc_security_group_ids = ["sg-xxxxxxxxxxx"]  
  subnet_id              = "subnet-0c33f0a44b827534c"

  tags = {
    Lab   = "5"
    
  }
}
```
5. Modifica los parámetros: 
* Key_name indicando la key usada en el primer lab
* vpc_security_group_id con el id del security groups del primer lab o cualquier Security Group que permita acceso por el puerto 80 desde internet (0.0.0.0/0).
* subnet_id indicando el id de vuestra main_subnet_a (la subnet pública del primer lab)

6. Lanzamos la creación de nuestros recursos con los siguientes comandos:
```bash
terraform init
terraform plan
terraform apply
```
**Nota**: podeís lanzar también estás 3 instancias a través de la consola si os funciona con terraform. Utilizad como base la ami generada en el laboratorio anterior, y en lugar de crear 1 sola instancia, cread las 3 a la vez. No necesitáis habilitar la IP pública!.

7. Comprobamos que nuestras 3 EC2 se han levantado correctamente desde el dashboard de AWS.
8. Dentro del panel de EC2, en el panel izquierdo, clicaremos sobre Load Balancers
9. Clicamos sobre la _Create load balancer_ y seleccionamos Network Load Balancer
10. Indicamos _myfirstLB_ en load balancer name y dejamos el resto de parámetros por defecto de _Basic Configurations_. Revisad que está marcada la opción Internet facing, ya que queremos acceder a la aplicación desde internet.
11. En el apartado _Networking mapping_ seleccionamos nuestra vpc principal _main_vpc_yourname_ y en el mapping seleccionamos la az-a. Recordad que en la az-a es dónde tenemos nuestra subnet pública. Indicaremos que la IP nos la asigne AWS.
12. Seleccionaremos un SG que hayamos utilizado en algún otro laboratorio. En principio cualquier que permita el acceso por el puerto 80.
13. En el apartado Listener and Routing, indicamos el protocolo:
* HTTP: 80
* En default action, veréis que el desplegable está vacío. Aún no hemos creado ningún TG, por lo que no podemos asociar el destino hacía el que balancer nuestra peticiones. Vamos a crearlo, clicando sobre el enlace _Create target group_
14. Selecciona _Instances_ como tipo de Target Group y en el nombre indicamos lab5. En el apartado Protocol:Port, de nuevo indicaremos el puerto 80 con el protocolo TCP.
15. En el apartado de Networking, seleccionaremos nuestra vpc main.
16. En el apartado _Health check_ dejaremos por defecto HTTP y / como path. Si clicais sobre _Advance health check settings_ veréis que podemos modificar los parámetros que hemos visto en clase. Vamos a modificar el timeout a 5 segundos, y clicamos sobre el botón _Next_.
17. En la siguiente pantalla, deberemos escoger las 3 instancias que hemos creado en los puntos anteriores y clicamos sobre el botón _include pendings below_ y clicamos _create target group_

Volvemos a la plantalla de creación del balanceador y en el desplegable Target Group ya deberíamos poder ver nuestro recién creado TG lab5.

18. Seleccionamos TG lab5, añadimos el tag Lab 5 a nuestro balanceador y clicamos sobre el botón _Create Load balancer_

## Verificación del funcionamiento del LB

Una vez creado nuestro load balancer, vamos a comprobar como balancea las peticiones a las diferentes EC2 que forman el target group.

19. En el dashboard de EC2, en las opciones de la izquierda, clicamos sobre _load balancer_
20. Seleccionamos nuestro load balancer _myfirstLB_ y nos vamos a la pestaña _Details_
21. Copiamos el DNS Name y lo llevamos a un navegador. ¿Que resultado tienes?
22. Abre una ventana de modo incógnito y refresca la url. Comprueba el resultado. ¿La petición la está devolviendo la misma EC2 (ip privada)? 
23. Repite varias veces el refresco y comprueba que va cambiando la EC2 que responde la petición.

## Sticky session LB

En esta sección cambiaremos la configuración de nuestro ELB para que funcine con sticky sessions

24. Volvemos al dashboard de EC2 y clicamos sobre _Target Groups_ 
25. Clicamos sobre nuestro target group y seleccionamos la pestaña _Atributos_. Clicamos sobre el botón _Edit_
26. En _target selecction configurations_ y habilitamos la opción _Stickiness_ . 
27. Hacemos de nuevo la prueba del bloque anterior, copiando el DNS y llevándolo a un navegador. Repite el refresco cada X segundos durante un minuto y verifica que la internal IP es siempre la misma.
28. Haz la mismo con el dns del LB de otro compañero y verifica que siempre te duelve la misma IP privada.

## Creación de un RDS

En este apartado vamos a crear una RDS y una EC2 desde la que conectarnos.

29. Accedemos al dashboard de RDS y clicamos sobre el botón en _Create Database_. El método de creación será el Standard.
30. Seleccionaremos el motor de base datos Aurora compatible with Mysql y dejamos la versión por defecto.
31. Escogemos la template Dev/test.
32. Indicaremos como identificador myfirstrds. Dejamos como master username: admin y como password indicad el que consideréis.
33. Seleccionaremos la Instance configuration burstable classes y seleccionamos db.t3.medium.
34. En el apartado Availabilty & Durability, seleccionamos el deployment _Create an Aurora Replica or Reader node in a different AZ_.
35. Finalmente, en el apartado Connectivity, seleccionaremos _Connect to an EC2 Compute resource_. En el desplegable, podéis escoger cualquier de las EC2 que ya tenemos desplegadas. (NOTA: Si no sale ninguna instancia, dadle al botón de recarga de este apartado)
37. En el apartado VPC security group (firewall), crearemos uno nuevo con el nombre: vpc_security_group_rds. El resto de parámetros, los dejamos con los valores por defecto. Clicamos en el botón _Create database_.
38. En principio, ya tendremos nuestra base de datos creada y enlazada con nuestra EC2.
39. Para poder acceder a nuestra RDS para crear nuestras bases de datos, debemos tener instalado Mysql en este caso.
40. Conectaos a la EC2 por SSH o bien a través de la propia consola de AWS e instalaremos Mysql con los siguientes comandos:
```
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf install mysql-community-server -y
```
40. Una vez instalado, podréis acceder a la rds con el siguiente comando:
```
mysql -u admin -p -h endpoint 
```
El endpoint lo podéis ver en el apartado Conectivity & Security si clicais sobre la rds (la primera instancia del desplegable) que acabais de crear.

41. Una vez dentro, podemos crear las bases de datos y tablas que necesitemos. Por ejemplo, puedes lanzar el siguiente comando para crear tu primera ddbb en nuestra RDS:
```
CREATE DATABASE myfirstdatabase;
```

42. Verifica que se haya creado correctamente
```
SHOW DATABASES;
```
43. Podemos verificar que tenemos los mismos datos en ambos instancias de RDS, haciendo un failover.
44. Desde la consola de RDS, selecciona la base de datos (Writer instance) y a través del botón _Actions_ y fuerza un Failover.
45. Una vez se haya realizado el failover, accede de nuevo a la instancia conectada a nuestra RDS y accede a la nueva writer indicado el endpoint correspondiente:
```
mysql -u admin -p -h endpoint
```
46. Verifica que las base de datos creada en la instancia principal, se mantiene tras hacer este failover:
```
SHOW DATABASES;
```
# Destrucción RDS
Para evitar consumo excesivos, vamos a eliminar nuestra RDS:

47. Accedemos de nuevo al panel de RDS y selecciona una de las instancias. Clica sobre el botón _Actions_ y selecciona _Delete_ . Repite este mismo paso con la instancia reader, qué probablemente ahora sea la writer.
48. Verás que el sistema realiza un backup de la rds de forma automática. Finalmente selecciona la instancia Regional Cluster y a través del botón actions elimina definitavamente la RDS. 

# Destrucción de las 3 instancias del TG

Para evitar un consumo excesivo, puede eliminar las 3 instancias que acabamos de crear de una manera sencilla.

49. Vuelve a la terminal del workstation: https://yourname-workstation.aprender.cloud/vscode
50. Verificamos que nos encontramos dentro del entorno que hemos creado (lab5) con el comando 
```bash
pwd
```
51. Escribimos en el terminal el siguiente código:
```bash
terraform destroy
```
52. Verifica en el dashboard de EC2 que se han eliminado las 3 instancias creadas.



