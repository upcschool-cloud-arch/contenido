# Configuración de las credenciales

## Explorando preferencia de configuración

* Visita la página de [configuración del CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) para revisar las opciones de configuración de credenciales disponibles.

### Actividad

* Discute con tu equipo qué tiene preferencia: ¿definir el Access Key/Secret Key en el fichero
`~/.aws/credentials` u obtenerlas del perfil que enlaza la máquina virtual con su *role*?

## Preparación

* Accede a la terminal de tu workstation, que debe de resider en tu propia cuenta de AWS.

## Reemplazando las credenciales

* Obtén la identidad que la CLI está utilizando actualmente para interactuar con AWS y apunta
contra qué cuenta del cloud estás trabajando y comprueba que se proporciona a través de un *role*

```bash
aws sts get-caller-identity
```

* Utiliza el servicio de metadatos para obtener las credenciales proporcionadas por dicho *role*

```bash
curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance/ ; echo
```

**NOTA: POR MOTIVOS OBVIOS DE SEGURIDAD, NUNCA LLEVAS A CABO EL SIGUIENTE PASO CON UNA CUENTA DE TRABAJO**

* Intercambia esas credenciales con otra persona de tu equipo.

* Investiga en la documentación sobre [las variables de entorno utilizadas por el CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) qué variables debes sobreescribir para fijar la región por defecto, el access key, la secret key y el token de sessión.

* Crea dichas variables en tu sesión de shell. Por ejemplo:

```bash
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=...
# ídem con la secret key
# ídem con el session token
```

* Invoca de nuevo el API de AWS para ver qué identidad se está utilizando ahora:

```bash
aws sts get-caller-identity
```

* Toma nota del número de cuenta de AWS y compáralo con el anotado anteriormente.