# LAB 3: EC2 features

En este lab, vamos a repasar algunas de las características principales que hemos visto en esta primera parte del módulo y retomaremos parte de lo que vimos en el módulo de Introducción al networking.

## Cambios en frío sobre EC2

En esta primera parte del lab, vamos a ver qué cambios en frío (parada de EC2) podemos hacer sobre la EC2

1. En primer lugar, crearemos una segunda EC2 **con IP pública** en nuestra subnet pública (main_subnet_a)
2. En el dashboard principal de aws buscamos el servicio EC2 en la barra del buscador o bien a través del menu _Services_
3. Clicamos sobre el botón _Launch instance_
4. Nuestra nueva EC2 tendrá el nombre _lab3_
5. En este caso, utilizaremos también la AMI Amazon Linux
6. Selecciona el tipo de instancia más grande que encuentres en free-tier (gratuita). Tip: ayúdate de la opción _Compare Instance Type_ que te aparece a la derecha.
7. En Key pair, clica sobre el menú desplegable y selecciona lab1 (creado en el módulo de Introducción al Networking). Si has perdido este fichero, crea un nuevo key pair con el mismo nombre _lab1_ y guárdalo.
8. Editaremos los Networking settings para que nuestra nueva instancia se cree dentro de nuestra vpc <main_vpc_yourname>, en la subnet pública <main_subnet_a> y habilitar la IP pública.
9. Selecciona el Security Group creado en los labs anteriores. Recuerda que debes tener acceso por HTTP (puerto 80), SSH (puerto 22) y orígen ip de tu laptop o PC y ping (Protocolo ICMP).
10. Dejaremos el almacenamiento con las caraterísticas que vienen por defecto
11. En advance details, añadiremos en el cuadro _User Data_:
```bash
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
#systemctl start httpd
#systemctl enable httpd
#echo "<h1>Hello I'm lab3 instance from $(hostname -f) </h1>" > /var/www/html/index.html
```
12. Clicamos sobre _Launch Instance_
13. **IMPORTANTE**:Comprobamos que la instancia ha finalizado su lanzamiento, en status check: _2/2 checks passed_
14. Lo primero que vamos a verificar es si nuestro apache esté iniciado, para ello, comprobamos mediante un curl 
```bash
curl http://<Ip pública>
```
15. ¿Qué resultado obtienes? 
16. Accedemos por ssh a nuestra instancia ec2 _lab3_:
 **Nota**: recuerda que podemos acceder a las instancias por dos vías:
 
--> La primera forma depende si tu equipo es Linux o Windows:
* Linux:
```bash 
ssh -i "lab1.pem" ec2-user@<IP publica>
````
* Windows: a través de putty y con el usuario ec2-user

--> La segunda forma es a través de la consola de AWS, usando el botón **_Connect_** que encontraréis arriba a la derecha de la pantalla en el menú EC2.

17. Una vez dentro comprobamos si httpd está levantado
```bash 
systemctl status httpd
```
18. ¿Qué resultado obtienes?
19. Vemos que ha habido algún problema con el arranque del servicio http. Vamos a ver dónde puede encontrarse el problema
20. Seleccionamos sobre nuestra instancia EC2 _lab_ en el dashboard de EC2 y clicamos sobre el botón arriba a la derecha _Actions_ .
21. Seleccionamos _Instance_Setting_ y buscamos la opción _Edit User Data_.
22. ¿Detectas algún problema en el código del _User Data_?
23. Si observamos con detenimiento, vemos que hay un error, ya que las líneas que inicializan httpd están comentadas/deshabilitadas con #.
24. Si intentamos eliminar estas almohadillas del código, veremos que tenemos deshabilitado el cuadro del código. No podemos modificarlo si la instancia está **running**.
25. Corregiremos este error más adelante, por el momento sigue adelante con lo siguientes pasos.

Ahora volveremos al tipo de instancia. ¿Recuerdas que tipo de instancia has escogido para esta EC2?. Posiblemente, nuestra futura aplicación no podrá ejecutarse en una instancia tan pequeña. 

25. ¿Recuerdas que tipo de escalado necesitaremos si queremos aumentar los recursos de nuestra EC2?
26. Necesitaremos un escalado Vertical (aumento de recursos como CPU y/o RAM). Para ello tendremos que cambiar el tipo de instancia. 
27. Busca una instancia de uso general que tenga el menor coste y 2 vCPU y 6 GiB de RAM. Ayúdate con los siguientes enlaces:
```
    https://calculator.aws/#/
    https://aws.amazon.com/es/ec2/instance-types
```
29. ¿Qué instancia has escogido?
30. Una vez tengamos decidido la nueva instancia que vamos a utilizar, tendremos que proceder con el escalado vertical. Para ello, nos vamos al menú EC2, seleccionamos nuestra instancia _lab3_ y clicamos sobre el botón de arriba a la derecha _Actions_--> _Instance settings_ --> _Change instance type_ 
31. Vemos que esta opción está deshabilitada. ¿Sabes cuál es el motivo?

Como ya hemos comentado, para poder realizar un cambio de tipo de instancia, es decir, escalado vertical, tenemos que parar la EC2. Este cambio **NO puede hacerse en caliente**, por lo que, si nuestro entorno fuese productivo, tendríamos que tener un ventana de mantenimiento con su correspondiente downtime.

31. Apagamos _lab3_, seleccionando nuestra EC2 en el panel y arriba a la derecha clicamos sobre _Instance state_ --> _Stop Instance_.
32. Volvemos a los pasos del punto 30. Y seleccionamos el tipo de instancia escogido en el punto 29 y aplicamos los cambios.
33. Verificamos que se ha producido el cambio de tamaño en el panel de EC2. Como véis el cambio es rápido, pero necesitamos parar la EC2 para hacerlo.
34. Aprovechamos que tenemos la EC2 parada, para realizar el cambio en el User Data
35. Seguimos las instrucciones del punto 21 y eliminamos la almohadilla de las líneas:
```bash
systemctl start httpd
systemctl enable httpd
```
36. Guardamos los cambios y levantamos de nueva la instancia desde _Instance state_ --> _Start instance_
37. Cuando la instancia se encuentre ya arrancada y los dos checks ok,comprobamos de nuevo si el servicio httpd está funcionando. Prueba de nuevo
```bash
curl http://<ip pública>
```
Ojo con la IP, está habrá cambiando respecto al momento previo a parar la instancia.
39. El servicio httpd sigue sin funcionar. El motivo es que el user data, por defecto, solo se ejecuta cuando la instancia se lanza. ¿Cómo arreglamos entonces está problema? Tenemos dos vías:

40. La primera, será "forzar la ejecución con cada reinicio. Para ellos, paramos de nuevo la instancia y incluiremos el siguiente texto en el User Data:
```
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
/bin/echo "Hello World" >> /tmp/testfile.txt
--//--
```

41. Arranca de nuevo la EC2, verifica que han pasado los checks y realiza de nuevo el curl.
42. La segunda opción, es modificar el User Data con lo comandos correctos y generar una AMI. A partir de esta AMI podemos crear las EC2 que necesitemos con el web server instalando y arrancado. Lo veremos en el próximo lab.
43.  Cuando hayas finalizado el lab, puedes parar la EC2.
