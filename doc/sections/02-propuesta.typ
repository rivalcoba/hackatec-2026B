= Descripción de la propuesta

PianiTech es un kit modular de *retrofitting* que incorpora vigilancia remota a talleres y PYMES con infraestructura *brownfield*. La propuesta integra sensores para observar máquinas rotatorias, presencia o concentración de gas, indicios de fuego y niveles de líquidos. Cada módulo asocia las lecturas con un dispositivo, activo, variable, unidad y marca de tiempo, y las publica mediante MQTT.

Un cliente desarrollado en Python se suscribe a los temas configurados, valida los mensajes, normaliza las lecturas y conserva su orden temporal. Después agrupa los datos en ventanas de operación y calcula características acordes con cada proceso, como mínimos, máximos, tendencia, variación, duración de estados y frecuencia de eventos. Sobre estas ventanas se aplica *Isolation Forest* para asignar una puntuación o clasificación de anomalía. El resultado no diagnostica por sí mismo una falla: señala comportamientos que requieren revisión y complementa los umbrales explícitos para condiciones críticas conocidas.

La solución contribuye a reducir la dependencia de inspecciones exclusivamente manuales y permite concentrar información de activos heterogéneos sin modificar su lógica interna. Su arquitectura desacopla adquisición, transporte y análisis, por lo que se pueden incorporar sensores o sustituir componentes de manera gradual.

En el ámbito regional, PianiTech ofrece una ruta accesible para modernizar talleres y negocios con equipos existentes. A escala nacional, el enfoque puede apoyar la adopción progresiva de tecnologías 4.0 en PYMES. Su estructura basada en MQTT, mensajes identificables y procesamiento modular facilita adaptar la propuesta a otros contextos productivos, conservando la evaluación de riesgos correspondiente.
