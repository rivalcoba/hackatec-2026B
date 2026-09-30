= Herramientas tecnológicas empleadas

Para armar y validar el prototipo se seleccionaron componentes accesibles y compatibles:

- *Control:* Arduino Uno y Sensor Shield para gestionar conexiones de alimentación y señales.
- *Actuadores:* motor paso a paso 28BYJ-48, motor DC 130 con hélice y módulo ULN2003 para potencia y protección.
- *Sensores:* sensor de nivel de agua, sensor infrarrojo de flama y botón de control para activar o detener el motor.
- *Alimentación e interconexión:* módulo MB102, batería de 9 V, cable USB y cables Dupont.
- *Software:* Arduino IDE, bibliotecas de soporte, código embebido y Flask para desarrollar el cliente de monitoreo.
- *Comunicación MQTT:* se utilizó MQTT (*Message Queuing Telemetry Transport*) con Mosquitto como broker. Es un protocolo ligero de publicación y suscripción que consume poco ancho de banda, organiza la telemetría por dispositivo, activo o variable y desacopla sensores y aplicaciones. Esta combinación es pertinente para PianiTech porque facilita controlar la entrega de mensajes e integrar dispositivos limitados de forma escalable.
