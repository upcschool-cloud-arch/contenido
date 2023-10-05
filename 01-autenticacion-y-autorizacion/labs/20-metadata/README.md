# Explorando los servicios de metadatos

En esta actividad exploraremos cómo consiguen las aplicaciones ejecutadas en EC2 las credenciales
necesarias para trabajar con la infraestructura.

## Credenciales de Role en EC2 y Metadata

* Accede a la terminal de tu *workstation* usando la url correspondiente (`https://XXXXXXXX-workstation.aprender.cloud/vscode/proxy/7681`)

* Comprueba que tienes conectividad con el servicio de metadatos

```bash
curl http://169.254.169.254/latest/meta-data/
```

* Explora la construcción de URLs para obtener distintos datos sobre la máquina

```bash
curl http://169.254.169.254/latest/meta-data/; echo
curl http://169.254.169.254/latest/meta-data/local-hostname; echo
```

### Actividades

* Partiendo de `http://169.254.169.254/latest/meta-data/identity-credentials/` consigue recuperar el *Access Key*
junto al resto de datos de autenticación proporcionados por el *role* asociado a la máquina.

<details>
<summary>Solución:</summary>
<code>
curl http://169.254.169.254/latest/meta-data/identity-credentials/ec2/security-credentials/ec2-instance/ ; echo
</code>
</details>

## Metadata v2

La versión 2 del servicio de metadata se considera más segura, tras el incidente de [Capital One](https://securityboulevard.com/2020/06/the-capital-one-data-breach-a-year-later-a-look-at-what-went-wrong-and-practical-guidance-to-avoid-a-breach-of-your-own/). Se considera buena
práctica permitir solo este tipo de acceso al servicio de metadata.

Exploremos cómo puede utilizarse (es similar al uso que hacemos en *CloudShell*).

* Obtén el token de acceso y guárdalo en una variable

```bash
TOKEN=$(curl -s -X PUT \
   "http://169.254.169.254/latest/api/token" \
   -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
)
echo El token es $TOKEN.
```

* Utiliza el endpoint de metadata, pero esta vez proporcionando el token:

```bash
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/
```
