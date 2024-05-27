# Ficha del módulo

Seguimos programando: ahora que sabemos cómo gestionar proyectos de código utilizando `git`, podemos centrarnos
en la parte específica de desarrollo. Durante esta parte del módulo llevaremos a cabo una introducción a la
gestión de infraestructura con el AWS CLI y, sobre todo, al uso de Terraform.

## Módulos anteriores

- Funcionamiento de `git`
- Automatización con Terraform

## En este módulo

### Objetivos

* Entender la necesidad del proceso de automatización del despliegue de aplicaciones
* Comprender cómo aplicar la automatización de pipelines a software e infraestructura
* Discernir qué mecanismo de despliegue es más adecuado para cada situación

### Conceptos tratados

- [x] Stock de código
- [x] Tensiones entre agilidad y control de calidad
- [x] Continuous integration
- [x] Continuous delivery
- [x] Continuous deployment
- [x] Artefactos
- [x] Build vs Release pipelines
- [x] CICD platforms
    - [x] Jenkins
    - [x] CodePipeline, CodeCommit, CodeBuild y CodeDeploy
    - [x] GitLab y GitLab CICD
    - [x] GitHub y GitHub Actions
- [x] Funcionamiento de GitHub Actions
    - [x] Workflow
    - [x] Events
    - [x] Jobs
    - [x] Nodes
    - [x] Steps: Actions y Run
    - [x] Variables y el contexto `vars.`
    - [x] Secrests y el contexto `secrets.`
- [x] Pipeline phases:
    - [x] Trigger
    - [x] Checkout
    - [x] Linting
    - [x] Compiling
    - [x] Unit testing
    - [x] Security and compliance check
    - [x] Documentation generation
    - [x] Artifact packaging
    - [x] Integration testing
    - [x] Artifact publishing
    - [x] Deployment
    - [x] End to end testing (E2E)
- [X] GitOps
    - [x] Repositorio único
    - [x] Repositorio de infraestructura separado
- [X] Estrategias de despliegue
    - [x] In-place replacement
    - [x] Immutable infraestructure
    - [x] Rolling deployment
    - [x] Blue/green
    - [x] Canary
    - [x] Dark launches / feature toggles

### Quizzes

* TBD

### Storytelling

Toda la empresa está implicada en un esfuerzo de transformación cultural, abrazando el desarrollo
ágil de aplicaciones y productos. Gracias a la utilización del cloud, ha sido posible alcanzar una
reducción espectacular en los tiempos necearios para llevar ideas a la práctica, y los cambios
en infraestructura se han convertido en algo habitual.

Por su parte, los equipos de desarrollo también han hecho un esfuerzo importante de renovación,
creando proyectos basados en aplicaciones más pequeñas con ciclos de vida independiente y pasando
el código a producción de manera mucho más agresiva.

Sin embargo, esta aceleración ha venido acompañada de algunos desafíos. En particular, errores
en la actualización tanto de la infraestructura como en las aplicaciones han generado interrupciones
de servicio que empiezan a suponer un problema para los usuarios de la plataforma.

Por ello vamos a definir una serie de *pipelines* que permitan introducir comprobaciones antes
de llevar a cabo cambios, con lo que estamos seguros de que mejoraremos la calidad de los despliegues
tanto de versiones nuevas de las aplicaciones como de la infraestructura.