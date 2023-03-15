# LAB 4: EBS options

La idea de este laboratorio es comprobar todas las opciones que nos brinda este servicio de AWS.

## Cambios en caliente

1. En el Dashboard de EC2, vamos a iniciar alguna de las instancias que tengamos sobre nuestra subnet pública _main subnet_a y nos aseguramos que:
* Tiene el SG abierto para HTTP, ICMP, SSH
* Tenemos en el User Data el servicio de httpd incluido
* Si está parada, la inciamos con un start desde _Instance State_

2. Una vez comprobados los puntos anteriores, con la instancia seleccionada, nos vamos a la pestaña _Storage_ (parte baja de la pantalla)
3. Clicamos sobre el id del volumen _vol-xxxxxxxxxxx_, que nos llevará al dashboard de EBS y nuevamente clicamos sobre el id para ver las características de nuestro EBS.
4. El siguiente paso será realizar un cambio del tamaño del volumen y del tipo de EBS, mientras comprobamos que la máquina no sufre downtimes en el proceso.
5. Para ello, podemos monitorizar de forma sencilla tirando un ping a la máquina  o bien revisando que el servicio de http está levantado. Esto último podemos verlo a través del navegador usando la dirección:
```bash
http://<ip pública ec2>
````

Ojo: aseguraros que el servicio de http funciona antes de realizar el cambio del siguiente punto. Para ello: accede por ssh a la instancia y lanza el siguiente comando:
```
systemctl status httpd
```
Si no estuviera levantado, inícialo con:
```bash
systemctl start httpd
```

6. Procedemos con el cambio, clicando sobre el volumen que queremos hacer el cambio y clicamos sobre el botón _Modify_
7. Seleccionaremos el volumen de tipo io1 (recordad que era el más económico dentro de los Provisioned IOPs). Subimos el size a 10 GiB e indicamos 100 IOPS.
8. CLicamos sobre el botón _Modify_  y verificamos que durante el cambio no tenemos pérdida de ping ni de HTTP.

Iportante: Tened en cuenta, que si hacemos un resize de EBS, en un entorno real, tendremos que realizar también una extensión de disco para que se vea reflejado el cambio en el SO o en Disk Management. Esta configuración difiere enrte Windows y Linux:
* Linux: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html
* Windows: https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/recognize-expanded-volume-windows.html

9. Siguiendo las instrucciones y el casuítica correspondiente (procesador Intel) del link anterior, extendemos el disco de nuestro EBS
10. Nos conectamos por ssh a la ec2 dónde se encuentra el vollumen EBS
11. Una vez aquí, lanzamos el siguiente comando
```bash
sudo lsblk  
```
12. Obtendremos algo similar a la siguiente imagen:
```bash
[ec2-user ~]$ sudo lsblk                
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0   8G  0 part /
xvdf    202:80   0  24G  0 disk
```
13. Veremos que nuestra partición, /xvda1 (8GB)  tiene un tamaño diferentes al volumen (10 GB).
14. Extendemos la partición al nuevo tamaño del volumen (10GB) con el siguiente comando
```bash 
sudo growpart /dev/xvda 1
```
15. Una vez extendido deberíamos ver que el volumen y la partición tiene el mismo tamaño (10GB). Ejemplo en la siguiente imagen:
```bash
[ec2-user ~]$ sudo lsblk               
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  16G  0 disk
└─xvda1 202:1    0  16G  0 part /
xvdf    202:80   0  24G  0 disk
```
Ahora procedemos a la extensión del mount point 

16. Primero vamos a verificar las características de este mount point:
```bash
[ec2-user ~]$ df -hT
```
17. Con este comando, veremos un detalle similar al ejemplo siguiente:

```bash
[ec2-user ~]$ df -hT
Filesystem      Type   Size    Used   Avail   Use%   Mounted on
/dev/xvda1      ext4   8.0G    1.9G   6.2G    24%    /
/dev/xvdf1      xfs    24.0G   45M    8.0G    1%     /data
```
Aquí vemos que /dev/xvda1  aún tiene el size anterior todavía, y que se encuentra montado sobre "/"

18. Extendemos el mount point, según el tipo (ext4 o xfs)
```bash
sudo xfs_growfs -d /
```
19. y verificamos que la extensión se ha realizado correctamente, verificando que el size es de 10 G en nuestro mount point.
```bash
[ec2-user ~]$ df -hT
```

20. Un vez verificado esto, volvemos tipo de disco inicial. Clica de nuevo sobre el volumen que acabamos de modificar y clica sobre el botón _Modify_
21. Seleccionamos de nuevo el voumen de tipo gp2 y aplicamos los cambios.



## Creación de snapshots

En este apartado, vamos a trabajar con los snapshots. Recordad que por tema de permisos dentro del lab no podemos aplicar DLM (DataCycle Life Manager). 

22. Sobre la misma EC2 que hemos trabajado en el punto anterior, vamos a installar la CLI de AWS. Para ello accedemos por ssh a esta instancia y lanzamos los siguientes comandos:
```bash
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
23. Verificamos que se ha instalado correctamente:
```bash
aws --version
```

24. Clicamos sobre el volumen que hemos trabajado en el apartado anterior
25. Clicamos el botón _Actions_ y seleccionamos _Create snapshot_
26. En la descripción indicamos my first snapshot y añadimos el tag:
* Key: Lab; Value: 4
27. Clicamos sobre el botón _Create snapshot_

## Creación de nuestra propia AMI 

Como hemos comentado a lo largo de este módulo, podemos generar nuestras propias AMIs. Vamos a ver cómo se haría:

28. Desde la consola de EC2, a la izquierda, buscamos dentro del apartado: Elastic Block Store, el punto snapshots y clicamos sobre este.
29. Seleccionamos el snapshot creado en el punto anterior (Descripción My first snapshot) y clicamos sobre el botón _Create image from snapshot_
30. Lo primero que indicaremos será el nombre de nuestra nueva AMI: myfirstAMI, y en la descripción indicaremos lo My first AMI
31. Dejaremos el resto de parámetros que vienen por defecto y clicaremos sobre el botón _Create Image_
32. Ahora nos vamos al apartado _Images_ dentro de la consola EC2 y verificamos que nuestra imagen se ha creado.

Lanzaremos una instancia con este AMI y verificaremos que el servicio de httpd se encuentra instalado en nuestra nueva EC2. 
33. Seleccionamos la ami que acabamos de crear y clicamos sobre el botón _Launch instance from AMI_
34. Las características de la nueva EC2 seran:
* Name: lab4
* AMI:ya debería estar seleccionada la que acabamos de crear
* Instance type: t2.micro
* keypair: lab1.pem
* Network settings: VPC: _main_vpc_yourname; Subnet: main_subnet_a; Auto-assig public PI: eNABLE; SG creado en labs anteriores
* Configure storage: dejamos valores por defecto

35. clicamos _Launch instance_
36. Verfificamos que el servicio httpd está funcionando:
```bash
curl http://<ip pública>
```
37. Verificamos que está incluido aws cli:
```bash
aws --version
```

## Encriptación de volúmenes 

Ninguno de nuestros EBS se encuentra encriptado ahora mismo, si queremos encriptar sin necesidade de crear una máquina nueva, podemos hacerlo sin necesidad de parar nuestra EC2:
38. Seleccionamos ec2 _lab4 y nos vamos a la pestaña _Storage_
39. Clicamos sobre el volumen de esta EC2 
40. En el botón _Actions_ seleccionamos _Create snapshot_
41. En la descripción indicamos snapshot sin escriptar y en el tag: 
* Key:lab; Value:4
42. Creamos el snapshot con el botçon _create snapsjot_
43. En el dashboard de EC2, nos vamos a la izquierda y clicamos sobre _Snapshots_
44. Seleccionamos el snapshot que acabamos de crear y clicamos sobre el botón _Actions_
45. Seleccionamos _Copy snapshot_

Fijaros que en este punto, además de encriptar el volúmen, pero también podríamos cambiar la región de destino, para recrear nuestros volúmnenes o nuestras EC2 en otras regiones.

46. Dejamos la región por defecto y habilitamos la casilla _Encrypt this snapshot_
47. La key de KMS será la que nos aparezca por defecto y clicamos sobre el botón _Copy Snapshot_
48. Tened en cuenta que esto puede llevar un par de minutos. Una vez creado el snapshot, lo seleccionamos y le añadimos el nombre _encriptado_
49. Ahora crearemos el nuevo volúmen ya encriptado. Clicamos sobre el snpashot encriptado y en el menú _Actions_ clicamos sobre _Create volume from snpashot_
50. Dejamos por defecto todos los parámetros y añadimos los tags:
* Key: lab; Value: 4
* Key: Name; Value: vol_ecnriptado
51. Clicamos sobre _Create Volume_
52. Una vez creado esto, podemos atachar este volumen a la instancia que hemos estado trabajando a una instancia diferente.
53. En este caso atacharemos a la misma instancia, clicando sobre el volumnes y sobre el botón _Actions_ y seleccionamos _Attach volume_
54. Seleccionamos la instancia en el desplegable _Instance_ y dejamos el _Device name_ por defecto
55. Clicamos sobre el _Attach Volume_
56. Si volvemos al dashboard de EC2 y clicamos sobre la instancia que acabamos de modificar y vamos a la pestaña _Storage_
57. Aquí podemos ver los dos volumenes atachados a esta ec2. 
