# Ficha del módulo

Este primer módulo sobre *gitops* se centra en el primer componente de la palabra, es decir, en `git`. Veremos
cómo puede aplicarse a escenarios que no tienen que estar directamente relacionados con la tecnología, pero es
muy importante recordar que en el fondo *clouds* significa automatización, automatización significa programación
y programación implica la gestión de ficheros de texto. Y ahí es donde continuamente utilizaremos esta base de
datos de código para gestionar no solo la colaboración en su creación si no también la ejecución del mismo
mediante el uso de pipelines.

## Módulos anteriores

- Cómo funciona el API de AWS
- Autenticación y autorización
- Uso básico del AWS CLI, el comando `terraform`, etc
- El concepto de automatización

## En este módulo

### Objetivos

* Entender por qué es necesaria la gestión del código en un entorno colaborativo
* Comprender el funcionamiento interno de `git`, desmitificando su complejidad
* Aprender los comandos más habituales
* Aplicar un workflow de trabajo simple para colaborar

### Conceptos tratados
 
- [ ] git
- [ ] repository
- [ ] repo initialization
- [ ] commiting files
- [ ] `HEAD` and `HEAD~1`
- [ ] showing history of commits
- [ ] jumping between revisions
- [ ] branches
- [ ] showing differences between revisions
- [ ] merging
- [ ] conflicts and conflict resolution
- [ ] tags
- [ ] cloned repositories
- [ ] pushing and pulling
- [ ] bare repositories


### Storytelling

Ya hemos creado nuevas aplicaciones 100% cloud native con tecnología serverless, hemos migrado aplicaciones tradicionales
convirtiéndolas en cloud-friendly y tenemos interiorizado que la clave para ser efectivos en este entorno es conseguir
automatizar todo lo posible las tareas propias de la gestión de la infraestructura.

Sin embargo... no estamos familiarizados con `git`, el sistema de control de versiones más popular en la actualidad. Por
ello pedimos a la empresa que nos pague una formación especializada, de manera que todo el equipo se sienta confortable
usándolo.

Al cabo de unos días, un tipo curioso con la pinta de Patrick Stewart aparece y comienza a explicar una historia
sobre dos escritores que deseaban publicar un libro...
