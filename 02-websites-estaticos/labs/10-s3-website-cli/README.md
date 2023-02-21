# Aplicaciones estáticas


## Preparación

* Genera un nombre único para tu bucket

```bash
BLOG_NAME=blognumber$RANDOM
```

## Configuración de S3

* Crea el bucket

```bash
aws s3 mb s3://$BLOG_NAME
```

* Define la *resource policy* que permitirá que incluso usuarios no autenticados puedan leer de él

```bash
cat<< EOF > policy.json 
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Public s3 access",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$BLOG_NAME/*"
    }
  ]
}
EOF
```

* Asigna la policy al bucket

```bash
aws s3api put-bucket-policy --bucket $BLOG_NAME --policy file://policy.json
```

* Genera la configuración del bucket para que se comporte como un servidor web

```bash
cat<< EOF > statichost.json
{
  "IndexDocument": {
    "Suffix": "index.html"
  },
  "ErrorDocument": {
    "Key": "404.html"
  },
  "RoutingRules": [
    {
      "Redirect": {
        "ReplaceKeyWith": "index.html"
      },
      "Condition": {
        "KeyPrefixEquals": "/"
      }
    }
  ]
}
EOF
```

* Asocia el bucket a dicha configuración

```
aws s3api put-bucket-website --bucket $BLOG_NAME --website-configuration file://statichost.json
```

## Publicación del blog

* Fija la región de trabajo

```bash
REGION=us-east-1
```

* Instala [Hugo](https://gohugo.io), el generador de websites que utilizaremos

```bash
wget https://github.com/gohugoio/hugo/releases/download/v0.87.0/hugo_extended_0.87.0_Linux-64bit.tar.gz
tar xvf hugo_extended_0.87.0_Linux-64bit.tar.gz
./hugo version
```

* Descarga la plantilla para el website

```bash
git clone https://github.com/themefisher/airspace-hugo
```

* Genera el website a partir de la plantilla

```bash
cd airspace-hugo/exampleSite
~/hugo --themesDir ../.. --baseURL http://$BLOG_NAME.s3-website-$REGION.amazonaws.com
```

* Revisa el contenido (estará en la carpeta public)

```bash
ls public/
```

* Copia tu blog al bucket

```bash
aws s3 cp --cache-control max-age=3600 --recursive public/ s3://$BLOG_NAME
```

* ¡Accede a tu bucket!

```bash
echo The website url is: http://$BLOG_NAME.s3-website-$REGION.amazonaws.com
```


