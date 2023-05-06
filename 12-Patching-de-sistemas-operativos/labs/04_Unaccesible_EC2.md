# OBJETIVO 

Aprender a recuperar una instancia a la que no tenemos acceso.

### Escenario:

- En la empresa actual nos encontramos con que hay una instancia EC2 desplegada que gestiona una VPN dentro de nuestra infraestructura. Es un recurso legacy y se ha perdido el acceso a él ya que no tiene abierto el puerto 22 ni se sabe dónde está el .pem de esa instancia. 

- Tendremos que encontrar la manera de conseguir una información vital que existe dentro de la instancia
y además poder usar la misma IP cuando levantemos una nueva instancia con el mismo propósito.