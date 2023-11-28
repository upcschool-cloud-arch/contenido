# RETO - Despliegue de un Wordpress

En este laboratorio vamos a realizar la instalación de un wordpress , en una EC2 Ubuntu y una BBDD RDS Mysql en cluster.

## VPC

* Crear un VPC propio con redes privadas y públicas

* Crear VPC 10.0.0.0/16

* Crear subredes publicas 10.0.1.0/24 10.0.2.0/24 y privadas 10.0.3.0/24 10.0.4.0/24

* Crear Internet Gateway

* Modificar las tablas de enrutamiento


## EC2
* Crear un grupo de seguridad SBWeb con el puerto 22 y 80 abierto para acceso por SSH y consultar la web
  
* Instalación Ubuntu. 

![](images/01.png)

* IP Pública

![](images/02.png)

* Pantalla inicial Wordpress

![](images/03.png)



* Instalación de Apache, PHP, Mysql y Wordpress

```
sudo apt update
sudo apt install apache2 -y
sudo apt install mysql-server -y
sudo apt install php libapache2-mod-php php-mysql -y
php -v
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz
cd wordpress
sudo cp -r . /var/www/html
cd /var/www/html
sudo rm index.html
sudo nano wp-config.php
```



## BBDD

* Crear un Subnet Group con las redes privadas

* Crear un Security Group, SWbbdd con el puerto 3306 para acceso desde la EC2

* Lanzar un Mysql en multi-AZ o free-tier (a elegir),  con el grupo de subredes creado

* RDS para Wordpress

![](images/04.png)
![](images/05.png)
![](images/06.png)
![](images/07.png)
![](images/08.png)
![](images/09.png)


* Configuración inicial con el endpoint de la BBDD usuario y contraseña

![](images/10.png)
![](images/11.png)


## Creación wp-config.php
Crear un fichero wp-config.php con la configuración que te da wordpress al intentar conectar por primera vez.
![](images/12.png)
![](images/13.png)

* Configuración inicial Wordpress
![](images/14.png)
![](images/15.png)