# Lab 02 - Crear alerta para costes NAT GW

Idea general:

Se debería seguir las mismas instrucciones que el lab-01 pero en vez de seleccionar el template, es necesario seleccionar "Customize (advanced)" y luego aplicar un filtro por Tags.

Orden detallado de acciones:

1. selecctionar _Customize (advanced)_
2. Como _Budget type_, seleccionar _Cost Budget - Recommended_
3. Introducir el nombre en _Budget name_
4. Como periodicidad, normalmente se utiliza period igual a _monthly_ y recurrente para que la alarma se quede siempre activa
5. Se recomienda dejar _Budgeting method_ con el valor por defecto, _Fixed_
6. Poner el valor que consideréis como umbral de alerta. AWS proporciona un gráfico en el lateral derecho para ver el histórico y adaptar el valor. Como ayuda, este campo también presenta el consumo del último mes para poder fijar el valor más adecuado.
7. En _Budget scope_ se debe seleccionar el servicio que queremos tener controlado. Para ello hay que aladir un filtro seleccionando la opción de _Filter specific AWS cost dimensions_
8. De todoas las opciones de filtros, _Add filter_, veréis un desplegable en _Dimension_ para seleccionar según 
Servicio, Región, Uso Tag, etc.. Hay un pequeño detalle en este punto y es que veréis que no aparece el servicio de NAT GW, así que la alternativa es utilizar como _Dimension_ _Tag_ y utilizar el valor asignado al NAT GW.
9. Después de dejar los valores por defecto, en la siguente pantalla, debéis añadir una alerta mediante la acción _Add and alert threhold_. Al abrir esta opción, AWS Budget os permite seleccionar a qué porcentaje del umbra se debe enviar la alerta y a qué direcciones de correo electrónico. Se pueden añadir varias alertas a diferentes umbrales.
10. Al darle a _Next_ veréis la opción de añadir automatizaciones a los eventos generados por el servicio de Budget. Por ahora lo dejaremos con los valores por defecto y al seleccionar _Next_ y _Create Budget_ en el paso 5, _Review_ ya tendríais configurada la alerta.


