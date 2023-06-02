# Ficha del módulo

Seguimos programando: ahora que sabemos cómo gestionar proyectos de código utilizando `git`, podemos centrarnos
en la parte específica de desarrollo. Durante esta parte del módulo llevaremos a cabo una introducción a la
gestión de infraestructura con el AWS CLI y, sobre todo, al uso de Terraform.

## Módulos anteriores

- Cómo funciona el API de AWS
- Autenticación y autorización
- Uso básico del AWS CLI, el comando `terraform`, etc
- El concepto de automatización
- Git

## En este módulo

### Objetivos

* Comprender la diferencia entre programación imperativa y declarativa
* Entender en qué escenarios utilizaremos cada uno de estos paradigmas
* Aprender a buscar en la documentación del AWS CLI
* Interiorizar los conceptos básicos de Terraform
* Desarrollar el ciclo de trabajo habitual con Terraform

### Conceptos tratados
 
- [x] Infraestructura como Código
- [x] Lenguaje imperativo
- [x] Lenguaje declarativo
- [x] Automatización con scripts
- [x] Terraform
- [x] Terraform CLI
- [x] Proveedores
- [x] Variables
- [x] Outputs
- [x] Recursos
- [x] Bloques `data`
- [ ] Backends
- [x] `terraform init`
- [x] `terraform fmt`
- [x] `terraform validate`
- [x] `terraform plan`
- [x] `terraform apply`
- [x] `terraform output`
- [x] `terraform apply -destroy`
### Quizzes

* https://quizizz.com/admin/quiz/6454d4764dfa8f001e809d58

### Storytelling

Por fin vamos a poder coger las riendas de la gestión de nuestra infraestructura sin necesidad de
utilizar la consola web para ello: estamos decididos a aplicar los conceptos de Infraestructura como
Código a todos nuestros proyectos, entendiendo cómo definir la arquitectura de nuestros data centers
utilizando Terraform, y cómo aplicar scripts de automatización para llevar a cabo tareas repetitivas
o críticas, como la creación de backups o el aislamiento de instancias comprometidas.
