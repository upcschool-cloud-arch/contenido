# cf-ec2-instance.yaml

Esta plantilla de CloudFormation despliega el número de EC2 que le indiquemos. Las instancias no cuenta con el volumen EBS cifrado pero sí con una dirección pública para poder acceder a ella desde internet. Durante el despliegue, se instala y configura docker en la misma.

Hay que tener en cuenta que una vez creado el stack, para futuros cambios en el mismo se debe sustituir el parámetro `create-stack` por `update-stack`:
    
``` 
    aws cloudformation \
        create-stack \
        --region eu-central-1 \
        --stack-name ec2-instance-tf-stack \
        --output text \
        --template-body file://cf-ec2-instance.yaml
``` 