# CF-EC2-instance.yaml

Esta plantilla de CloudFormation despliega una instancia EC2 y su respectivo Security Group en una VPC de nueva creación, que cuenta con dos subredes en las dos primeras zonas de disponibilidad (AZs) de la región de AWS empleada. La instancia no cuenta con el volumen EBS cifrado pero sí con una dirección pública para poder acceder a ella desde internet. Durante el despliegue, se instala y configura docker en la misma.

Para su correcto despliegue se deben seguir los siguientes pasos:

1. crear una llave SSH (Key Pair) llamada `postgrado`. El certificado PEM de dicha llave se usará para acceder a la instancia.

2. lanzar la plantilla de CloudFormation para el despliegue de la VPC y, posteriormente, de la instancia. Este paso se puede hacer a través de la consola de administración de AWS o mediante el AWS CL, con un comando como este. 

Hay que tener en cuenta que una vez creado el stack, para futuros cambias en el mismo se debe sustituir el parámetro `create-stack` por `update-stack`:
    
``` 
    aws cloudformation \
        create-stack \
        --region eu-central-1 \
        --stack-name ec2-instance-tf-stack \
        --output text \
        --template-body file://cf-ec2-instance.yaml
``` 