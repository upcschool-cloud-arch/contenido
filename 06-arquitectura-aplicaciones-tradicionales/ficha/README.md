# Ficha del módulo

Una vez visto como estructurar las redes en AWS, podemos comenzar a desplegar recursos. Algunos de los más usados en arquitecturas "tradicionales" y con poca transformación, serán las EC2 como prinicpal elemento de IaaS, y RDS como ejemplo de servicio PaaS. 
El diseño y configuración de estos recursos, al igual que las redes, debe plantearse de acuerdo a nuestras necesidades y según el nivel de criticidad de nuestros entornos. Una configuración inadecuada puede ocasionar SPof (puntos de fallo únicos) poniendo en riesgo la continuidad del negocio. Por tanto, será primordial encontrar el balance entre criticidad y costes para adecuar la configuración de los recursos.


## Módulos anteriores

* Autorización y autenticación
* Introducción al networking

## En este módulo

### Objetivos

* Comprender diferencias entre IaaS y PaaS
* Diseñar y configurar arquitecturas "tradicionales" en AWS utilizando algunos servicios nativos
* Comprender modelo de precios de EC2 y RDS
* Entender el conceto de balanceador de carga y el servicio ELB de AWS
* Detección de SpoF en arquitecturas sencilas
* Comprender el escalado vertical y horizontal en EC2 y RDS

### Conceptos tratados

- [x] EC2: tipos, características, etc
- [x] EBS: tipos y características 
- [x] Modelo de precios de EC2: on-demand, reservas, spots, dedicated hosts, savings plans...
- [X] Otros tipos de almacenamiento: introdccucción a EFS y FSx
- [X] Repaso IAM users, groups, roles & policies
- [x] Introducción a escalado vertical y horizontal
- [x] RDS: tipos, características, etc
- [x] Introducción Amazon Aurora
- [x] Placement groups  
- [x] SPoF
- [x] ELBs: tipos y características como sticky sessions
- [x] Introducción a ASG

### Quizzes

* https://quizizz.com/admin/quiz/5e5cecb04338c6001b1df599

### Storytelling

*Es importante recordar que el 90% de las aplicaciones existentes siguen los mismos patrones que han acompañado al desarrollo durante los últimos 20 años, 
dado que están siendo construidas por las mismas personas que se han encargado de implementarlas durante este tiempo. En este módulo continuaremos con el
proyecto anterior,  trabajando los recursos desplegables en la red anteriormente creada:  un balanceador de carga que repartirá las peticiones a la flota
de computación basada en dos servidores y una base de datos relacional como mecanismo de almacenamiento principal. Es importante explicar el concepto de
single point of failure, y cómo estamos aplicando alta disponibilidad en cada una de las capas aunque de momento sea de forma sencilla.*

## Grabaciones

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/t88aH2KjAcA/0.jpg)](https://www.youtube.com/watch?v=t88aH2KjAcA)


