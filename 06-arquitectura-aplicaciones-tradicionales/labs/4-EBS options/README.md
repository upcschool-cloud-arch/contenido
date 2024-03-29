# LAB 4: EBS options

La idea de este laboratorio es comprobar todas las opciones que nos brinda este servicio de AWS.

## Cambios en caliente

1. En el Dashboard de EC2, vamos a iniciar la instancia del lab3. Recordemos que esta se encuentra en la subnet pública _main subnet_a. Antes de seguir, verifica los siguientes puntos:
* Tiene el SG abierto para HTTP, ICMP, SSH
* Tenemos en el User Data el servicio de httpd incluido y levantado**
* Si está parada, la inciamos con un start desde _Instance State_

** **Nota**: si el web server no está levantado, es decir, no obtenemos la respuesta "Hello I'm lab3 instance from ip-xxx-xx-x-xxx.ec2.internal" al hacer un curl al lanzar la petición en el navegador:
```bash
http://<ip_publica>
```
levánta el servicio manualmente, tal como se indica a continuación:
```
systemctl status httpd
```
Si no estuviera levantado, inícialo con:
```bash
systemctl start httpd
```

2. Una vez comprobados los puntos anteriores, con la instancia seleccionada, nos vamos a la pestaña _Storage_ (parte baja de la pantalla)
3. Clicamos sobre el id del volumen _vol-xxxxxxxxxxx_ (esto nos llevará al dashboard de EBS) y añade a este volumen el tag "EBS_lab3" para que te sea más fácil identificarlo.
4. Nuevamente clicamos sobre el id para ver las características de nuestro EBS (tamaño, tipo, snapshots, etc).
5. El siguiente paso será realizar un cambio del tamaño del volumen y del tipo de EBS, mientras comprobamos que la máquina no sufre downtimes en el proceso.
6. Para ello, podemos monitorizar de forma sencilla tirando un ping a la máquina  o bien observando servicio de http, que debería estar está levantado en todo momento. Esto último podemos verlo a través del navegador usando la dirección:
```bash
http://<ip pública ec2>
````
**Nota**: también podríamos monitorizar la EC2 a través de Cloudwatch.

7. Vamos a proceder con el cambio de tamaño y tipo de EBS. Podéis hacerlo desde dos puntos:
* La primera opción es seleccionar el volumen EBS_lab3 y clicamos sobre el botón _Actions_ que encontraréis arriba a la derecha. Seguidamente clicais sobre _Modify volume_ .
* La segunda opción, es desde el paso 4. Si estamos dentro de las características de nuestro volumen, veremos arriba a la derecha el botón _Modify_.
8. Seleccionaremos el volumen de tipo io1 (recordad que era el más económico dentro de los Provisioned IOPs). Subimos el size a 10 GiB e indicamos 100 IOPS.
9. CLicamos sobre el botón _Modify_ y verificamos que durante el cambio no tenemos pérdida de ping ni de HTTP.
**Importante**: Tened en cuenta que, si hacemos un resize de EBS en un entorno real, tendremos que realizar también una extensión de disco para que se vea reflejado el cambio en el SO o en Disk Management. Esta configuración es diferente según el Sistema Operativo de nuestra EC2:
* Linux: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
* Windows: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/recognize-expanded-volume-windows.html

10. Siguiendo las instrucciones y el casuítica correspondiente (procesador Intel) del link anterior, vamos a extender el disco de nuestro EBS.
11. Nos conectamos por ssh o a través de la consolo de AWS a la EC2 lab3 (o dónde se encuentre el volumen que estamos trabajando: EBS_lab3)
12. Una vez aquí, lanzamos el siguiente comando
```bash
sudo lsblk  
```
13. Este comando nos lista las particiones y volúmenes que tenemos en nuestra máquina. Obtendremos algo similar a la siguiente imagen:
```bash
[ec2-user ~]$ sudo lsblk                
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0   8G  0 part /
xvdf    202:80   0  24G  0 disk
```
14. Veremos que nuestra partición, /xvda1 (8GB)  tiene un tamaño diferentes al volumen xvda, que tiene un tamaño de 10 GB y corresponde al cambio que hemos hecho en el paso 8.
15. Extendemos la partición al nuevo tamaño del volumen (10GB) con el siguiente comando:
```bash 
sudo growpart /dev/xvda 1
```
16. Una vez extendido deberíamos ver que el volumen y la partición tiene el mismo tamaño (10GB). Lanza de nuevo el comando del paso 13:
```bash
[ec2-user ~]$ sudo lsblk               
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0  16G  0 part /
xvdf    202:80   0  24G  0 disk
```
Ahora deberíais ver que la partición y el volumen coinciden en tamaño tal como se muestra en el ejemplo anterior. El siguiente paso será proceder a la extensión del mount point.

17. Primero vamos a verificar las características de este mount point:
```bash
[ec2-user ~]$ df -hT
```
18. Con este comando, veremos un detalle similar al ejemplo siguiente:

```bash
[ec2-user ~]$ df -hT
Filesystem      Type   Size    Used   Avail   Use%   Mounted on
/dev/xvda1      ext4   8.0G    1.9G   6.2G    24%    /
/dev/xvdf1      xfs    24.0G   45M    8.0G    1%     /data
```
Aquí vemos que /dev/xvda1  aún tiene el size anterior todavía, y que se encuentra montado sobre "/"

19. Extendemos el mount point, según el tipo (ext4 o xfs)
```bash
sudo xfs_growfs -d /
```
20. y verificamos que la extensión se ha realizado correctamente, verificando que el size es de 10 G en nuestro mount point.
```bash
[ec2-user ~]$ df -hT
```

21. Pasada una hora aproximadamente, podemos volver al tipo de disco inicial. Clica de nuevo sobre el volumen que acabamos de modificar y clica sobre el botón _Modify_ .
22. Seleccionamos de nuevo el volumen de tipo gp3 y aplicamos los cambios.



## Creación de snapshots

En este apartado, vamos a trabajar con los snapshots. Recordad que por tema de permisos dentro del lab no podemos aplicar DLM (DataCycle Life Manager). 

23. Sobre la misma EC2 que hemos trabajado en el punto anterior, vamos a installar la CLI de AWS. Para ello accedemos por ssh a esta instancia y lanzamos los siguientes comandos:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
24. Verificamos que se ha instalado correctamente:
```bash
aws --version
```

25. Clicamos sobre el volumen que hemos trabajado en el apartado anterior
26. Clicamos el botón _Actions_ y seleccionamos _Create snapshot_
27. En la descripción indicamos "my first snapshot" y añadimos el tag:
* key: Name; Value:lab4
28. Clicamos sobre el botón _Create snapshot_

## Creación de nuestra propia AMI 

Como hemos comentado a lo largo de este módulo, podemos generar nuestras propias AMIs. En este laboratorio, crearemos uns plantilla que contendrá tanto la CLI de aws como un webserver ya configurado. Vamos a ver cómo:

29. Desde la consola de EC2, a la izquierda, buscamos dentro del apartado: Elastic Block Store, el punto snapshots y clicamos sobre este.
30. Seleccionamos el snapshot creado en el punto anterior _lab4_ y clicamos sobre el botón _Create image from snapshot_
31. Lo primero que indicaremos será el nombre de nuestra nueva AMI: myfirstAMI, y en la descripción indicaremos lo My first AMI
32. Dejaremos el resto de parámetros que vienen por defecto y clicaremos sobre el botón _Create Image_
33. Ahora nos vamos al apartado _Images_ dentro de la consola EC2 y verificamos que nuestra imagen se ha creado.

Lanzaremos una instancia con este AMI y verificaremos que el servicio de httpd se encuentra instalado en nuestra nueva EC2.

34. Seleccionamos la ami que acabamos de crear y clicamos sobre el botón _Launch instance from AMI_
35. Las características de la nueva EC2 seran:
* Name: lab4
* AMI:ya debería estar seleccionada la que acabamos de crear
* Instance type: t2.micro
* keypair: lab1.pem
* Network settings: VPC: _main_vpc_yourname; Subnet: main_subnet_a; Auto-assign public IP: Enable; SG creado en labs anteriores
* Configure storage: dejamos valores por defecto

36. clicamos _Launch instance_
37. Esperamos a que el los checks esten ok y verfificamos que el servicio httpd está funcionando:
```bash
curl http://<ip pública>
```
38. Verificamos que está incluido aws cli:
```bash
aws --version
```

## Encriptación de volúmenes 

Ninguno de nuestros EBS se encuentra encriptado por el momento. Recordad, que podemos cambiar esto sin necesidad de parar nuestra EC2. Vamos a ver cómo:

39. Seleccionamos ec2 _lab4_ y nos vamos a la pestaña _Storage_
40. Clicamos sobre el volumen de esta EC2 
41. En el botón _Actions_ seleccionamos _Create snapshot_
42. En la descripción indicamos snapshot sin escriptar y en el tag: 
* Key:Name; Value: lab4
43. Creamos el snapshot con el botón _create snapshot_.
44. En el dashboard de EC2, nos vamos a la izquierda y clicamos sobre _Snapshots_
45. Seleccionamos el snapshot que acabamos de crear y clicamos sobre el botón _Actions_
46. Seleccionamos _Copy snapshot_

Fijaros que en este punto, además de encriptar el volúmen,también podríamos cambiar la región de destino, para recrear nuestros volúmenes o EC2 en aquella región que nos interese.

47. Dejamos la región por defecto y habilitamos la casilla _Encrypt this snapshot_
48. La key de KMS será la que nos aparezca por defecto y clicamos sobre el botón _Copy Snapshot_
49. Tened en cuenta que esto puede llevar un par de minutos. Una vez creado el snapshot, lo seleccionamos y le añadimos el nombre _encriptado_.
50. Ahora crearemos el nuevo volúmen ya encriptado. Clicamos sobre el snapshot encriptado y en el menú _Actions_ clicamos sobre _Create volume from snapshot_
51. Dejamos por defecto todos los parámetros y añadimos los tags:
* Key: lab; Value: 4
* Key: Name; Value: vol_encriptado
52. Clicamos sobre _Create Volume_
53. Una vez creado esto, podemos atachar este volumen a la instancia que hemos estado trabajando o a otra instancia.
54. En este caso atacharemos a la misma instancia, clicando sobre el volúmenes y sobre el botón _Actions_ y seleccionamos _Attach volume_
55. Seleccionamos la instancia en el desplegable _Instance_ y dejamos el _Device name_ por defecto
56. Clicamos sobre el _Attach Volume_
57. Si volvemos al dashboard de EC2 y clicamos sobre la instancia que acabamos de modificar y vamos a la pestaña _Storage_
58. Aquí podemos ver los dos volumenes atachados a esta ec2. 
