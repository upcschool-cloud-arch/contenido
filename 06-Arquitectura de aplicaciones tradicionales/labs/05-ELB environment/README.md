# LAB 5: ARQUITECTIRA TRADICIONAL

En este lab, crearemos una pequeña arquitectura basada el un ELB que nos permitirá distribuir las peticiones entre las instancias que formarán el TG:


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
  user_data = << EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
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
* vpc_security_group_id con el id del security groips del primer lab
* subnet_id indicando el id de vuestra main_subnet_a (la subnet pública del primer lab)

6. Lanzamos la creación de nuestros recursos con los siguientes comandos:
```bash
terraform init
terraform plan
terraform apply
```
7. Comprobamos que nuestras 3 EC2 se han levantado correctamente desde el dashboard de AWS.
8. Dentro del panel de EC2, abajo a la izquierda, clicaremos sobre ELB
9. Clicamos sobre la _Create load balancer_ y seleccionamos Network Load Balancer
10. Indicamos _mifirstLB_ en load balancer name y dejamos el resto de parámetros por defecto de _Basic Configurations_
11. En el apartado _Networking mapping_ seleccionamos nuestra vpc principal _main_vpc_yourname_ y em mapping seleccionamos la az-a
12. En el apartado Listener and Routing, indicamos el protocolo:
* HTTP: 80
* En default action, clicamos sobre el enlace _Create target group_

En este punto crearemos el nuevo Target Group:

13. Selecciona Instances como tipo de Target Group y en el nombre indicamos lab5
14. En la VPC, de nuevo seleccionamos nuestra _main_vpc_yourname_
15. En Tag añadimos:
* Key: lab; Value: 5
16. En el apartado _Healt check_ dejaremos por defecto TCP y clicamos sobre el botón _Next_
17. En la siguiente pantalla, deberemos escoger las 3 instancias que hemos creado en los puntos anteriores y clicamos sobre el botón _include pendings below_ y clicamos _create target group_

Volvemos a la plantalla de creación del balanceador y en el desplegable Target Group ya deberíamos poder ver nuestro recién creado TG lab5.

18. Seleccionamos TG lab 5, añadimos el tag Lab 5 a nuestro balanceador y clicamos sobre el botón _Create Load balancer_

## Verificación del funcionamiento del LB

Una vez creado nuestro load balancer, vamos a comprobar como balancea las peticiones a las diferentes EC2 que forman el target group.

19. En el dashboard de EC2, en las opciones de la izquierda, clicamos sobre _load balancer_
20. Seleccionamos nuestro load balancer _myfirstLB_ y nos vamos a la pestaña _Details_
21. Copiamos el DNS Name y lo llevamos a un navegador. ¿Que resultado tienes?
22. Abre una ventana de modo incógnito y refresca la url. Comprueba el resultado. ¿La petición la está devolviendo la misma ec2 (ip privada)? 
23. Repite varias veces el refresco y comprueba que va cambiando la EC2 que responde la petición.

## Sticky session LB

En esta sección cambiaremos la configuración de nuestro ELB para que funcine con sticky sessions

24. Volvemos al dashboard de EC2 y clicamos sobre _Target Groups_ 
25. Clicamos sobre nuestro target group y seleccionamos la pestaña _Atributos_. Clicamos sobre el botón _Edit_
26. En _target selecction configurations_ y habilitamos la opción _Stickiness_
27. Definiremos un tiempo para este lab de 1 un minuto, pero lo ideal sería definirlo según las necesidades de nuestra aplicación. Por ejemplo: ¿cuánto tiempo de media puede tardar un usuario en hacer una compra en nuestro e-commerce?
28. Guardamos los cambios.
29. Hacemos de nuevo la prueba del bloque anterior, copiando el DNS y llevándolo a un navegador. Repite el refresco cada X segundos durante un minuto y verifica que la internal IP es siempre la misma.
30. Haz la mismo con el dns del LB de otro compañero y verifica que siempre te duelve la misma IP privada.

# Destrucción de las 3 instancias del TG

Para evitar un consumo excesivo, puede eliminar las 3 instancias que acabamos de crear de una manera sencilla.

31. Vuelve a la terminal del workstation: https://yourname-workstation.aprender.cloud/vscode
32. Verificamos que nos encontramos dentro del entorno que hemos creado (lab5) con el comando 
```bash
pwd
```
34. Escribimos en el terminal el siguiente código:
```bash
terraform destroy
```
33. Verifica en el dashboard de EC2 que se han eliminado las 3 instancias creadas.



