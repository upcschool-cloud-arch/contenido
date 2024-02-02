## Ejemplos de código Terraform para desplegar infraestructura en Azure

Aquí os dejo algunos ejemplos de cómo desplegar con Terraform algunos elementos de los que se habla en el temario, pero en Azure. Espero que os sean útiles! 
Alguno es prácticamente calcado de los ejemplos que hay en la documentación de Microsoft (https://learn.microsoft.com/en-us/azure/developer/terraform/), otros contienen alguna funcionalidad adicional, de las que típicamente se usan cuando se despliega infraestructura (reglas de firewall, backups, etc...)

## Estructuración del código

Aunque más o menos se sigue la estructura típica de código Terraform (ficheros TF main, outputs, variables...), he optado por crear un número mayor de archivos para tener los recursos segregados por tipos (cómputo, redes, backups, etc...) para saber a dónde ir a buscar en caso de que falle algo. Además, la mayoría de opciones que nos puede interesar cambiar están definidas como variables en el fichero *variables.tf* de manera que si queremos modificar parámetros que como el número de nodos de un cluster, la retención de un backup o cosas así sólo tendremos que ir a ese archivo a modificar la variable correspondiente. 

## Descripción de los ejemplos 

* storage: Un simple ejemplo de como crear un storage account (más o menos el equivalente a un bucket S3) añadiendo alguna opción para limitar el acceso. 
* vm: Creación de una máquina virtual que contiene un servidor web accesible desde Internet. 
* vmcluster: Creación de un conjunto de máquinas virtuales con un servidor web instalado. Se puede acceder a su contenido mediante un balanceador.
* sql: Creación de una instacia de base de datos de SQL Server, y configuración de réplica automática y copias de seguridad.
* aks: Despliegue de un cluster de Kubernetes y posteriormente despliegue de una aplicación web en dicho cluster.

## Fe de erratas

Todo este código está hecho por manos inexpertas!! Sentíos libres de corregir/añadir/modificar cosas :)