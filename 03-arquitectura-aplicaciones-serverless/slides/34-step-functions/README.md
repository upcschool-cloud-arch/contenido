## AWS Step Functions

AWS Step Functions proporciona máquinas de estado totalmente administradas en la nube.
Step Functions le permite coordinar varios servicios de AWS en máquinas de estado serverless para que pueda crear y actualizar aplicaciones rápidamente.

Con Step Functions, puede diseñar y ejecutar flujos de trabajo que combinen servicios como AWS Lambda, AWS Fargate y Amazon SageMaker en aplicaciones con muchas funciones.

Puedes escribir flujos de trabajo resilientes con gestión de errores integrada y soporte para reintentos. Además, Step Functions puede proporcionar un historial de ejecución audible con supervisión visual de las ejecuciones de su máquina de estado, lo que le permite rastrear y depurar visualmente cuando sea necesario.

### Máquinas de estado en Step Functions

Un workflow creado en AWS Step Functions:

- Está construido con una máquina de estado
- Se compone de pasos llamado estados
- Se define usando Amazon States Language (ASL)
- Se puede utilizar para orquestar varios servicios de AWS

Una máquina de estados, describe una colección de pasos computacionales divididos en estados discretos.

Tiene un estado inicial y siempre un estado activo (durante la ejecución) El estado activo recibe entradas, realiza alguna acción y genera salidas

Las transiciones entre los estados se basan en las salidas de estado y las reglas que definir

### Por ejemplo: procesamiento de imágenes

- Haz una miniatura
- Identifica las características
- Almacenar metadatos de imágenes

![images](./images/01.png)

### Tipos de estados

- Task: Execute work
- Choice: Add branching logic
- Wait: Add a timed delay
- Parallel: Execute branches in parallel
- Map: Process each of an input array's items with a state machine
- Succeed: Signal a successful execution and stop
- Fail: Signal a failed execution and stop
- Pass: Pass input to output

### Integraciones de Step Functions

![images](./images/02.png)

**Integraciones de AWS SDK:** Llame directamente a 200 servicios de AWS (Más de 9000 APIs)

## Lab

- [Lab 01 - Crear una máquina de estados](../../labs/34-step-functions/34-01-lab.md)
- [Lab 02 - Modificar la máquina de estado](../../labs/34-step-functions/34-02-lab.md)

## More information and material

[Check this file](materiales.md)
