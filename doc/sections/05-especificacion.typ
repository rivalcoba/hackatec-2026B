= Especificación técnica de la propuesta

== Características ténicas esperadas
La especificación técnica de PianiTech reúne las capacidades funcionales y operativas que deberá cumplir el prototipo para adquirir, transmitir, organizar y analizar la telemetría de los activos monitoreados. Estas características orientan su implementación, sus pruebas y la evaluación de su funcionamiento:

- Adquisición modular para rotación, gas, fuego y nivel de líquidos.
- Mensajes con `deviceId`, `assetId`, variable, valor, unidad y marca de tiempo.
- Jerarquía MQTT que identifique taller, área, activo y tipo de dato.
- Validación de estructura y tipo; un mensaje inválido no debe detener el servicio.
- Separación entre telemetría, eventos y estado de dispositivos.
- Registro de interrupciones de comunicación y conservación del orden temporal.
- Ventanas configurables con características pertinentes para cada sensor.
- Puntuación o clasificación de anomalía mediante *Isolation Forest*.
- Arquitectura extensible sin rediseñar el flujo completo.
- Operación complementaria: no sustituye sistemas certificados, inspecciones ni controles de seguridad.

== Diagramas de diseño
TODO 