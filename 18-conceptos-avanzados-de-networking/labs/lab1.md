# Laboratorio de Redes Avanzadas

## Laboratorio 1 - VPC Peering

### Escenario

Nuestra empresa ha decidido realizar la miración de su infrastructura al cloud. Después de esta migración, nos damos cuenta que, dada la globalización del negocio, hay partes del mundo, donde, a causa de la distancia a nuestras instancias, el rendimiento de la red es muy bajo. Para mitigar esto, se propone replicar nuestra infrastructura a otras regiones, así efectivamente reduciendo la latencia y por consiguiente mejorando el rendimiento y la experiencia de usuario.

Como primera aproximación, se propone que se realize un VPC Peer entre las dos regiones seleccionadas. Por lo que nuestro objetivo será unir dos redes privadas de dos regiones diferentes.

**Pasos:**
* Creación de un VPC
* Creación de las máquinas

### Creación de los VPC
* Crear un VPC en N. Virginia
    * Nombre: Hub-VPC-US-EAST-1
    * Ir a "VPC and more"
    * Seleccionar un CIDR (que sea /16)
    * 1 NAT Gateway
    * 2 AZ
    * 2 Private & 1 Public Subnet

* Crear un VPC en Oregon
    * Nombre: Spoke-VPC-US-WEST-2
    * Ir a "VPC and more"
    * Seleccionar un CIDR (que sea /16 **Y Distinto al de N. Virginia**)
    * 1 NAT Gateway
    * 2 AZ
    * 2 Private & 1 Public Subnet

### Creación de las máquinas
#### Hub
* Crear un Ubuntu en North Virginia

* Editar la red:
    * Indica el Hub-VPC-US-EAST-1
    * Crear una nueva subred - **172.31.100.0/24**
        * Autoasignar IP: Yes
    * Security Group -- Allow ICMP y HTTP (por si queremos hacer pruebas)
        * Advanced Details
            - Select IAM: LabInstanceProfile

#### Spoke
* Hacer lo mismo para Oregon
* Crear un Ubuntu en Oregon

* Editar la red:
    * Indica el Spoke-VPC-US-WEST-2
    * Crear una nueva subred - **172.31.100.0/24**
        * Autoasignar IP: Yes
    * Security Group -- Allow ICMP y HTTP (por si queremos hacer pruebas)
        * Advanced Details
            - Select IAM: LabInstanceProfile

### Testing inicial
* Probar desde  N. Virginia hacer ping a las IP de Oregon:
    * Ping Public Network
    * Ping Private Network


### Peering
Como hemos dicho el peering no escala, ya que necesitamos hacer un peer por spoke.

El peering lo hacemos a través del VPC

#### VPC
* Peering connections: Create / Juntamos los dos VPC
* **Imortant**: Menu Actions: Accept Peering Request

#### EC2
Ahora tenemos que actualizar las tablas de routing de las subredes para que sepan que para llegar a la otra región tienen que ir por el peering.
* Instance - Network - Select Subnet - Route table
* 

