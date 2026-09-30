= Validación del modelo de negocio

Para analizar y fortalecer el modelo de negocio de PianiTech se empleó la metodología SCAMPER, que permite examinar una propuesta desde siete perspectivas: sustituir, combinar, adaptar, modificar, poner en otros usos, eliminar y reordenar o revertir. Su aplicación ayuda a identificar oportunidades de mejora en el enfoque de *retrofitting*, la arquitectura de la solución y su crecimiento gradual.

A continuación, se presentan las alternativas identificadas mediante cada componente de SCAMPER. Estas propuestas deberán complementarse con entrevistas y pruebas piloto en PYMES para validar necesidades, facilidad de instalación, utilidad de las alertas, presencia de falsos positivos, costos aceptables y posibles ajustes a la solución.

- *Sustituir:* reemplazar la modernización total de maquinaria por una capa externa de instrumentación.
- *Combinar:* integrar sensores heterogéneos, MQTT, ventanas temporales y *Isolation Forest* en un flujo común.
- *Adaptar:* configurar identificadores, frecuencia de muestreo, características y temas según cada activo.
- *Modificar:* iniciar con pocos puntos de monitoreo y ampliar la cobertura modularmente; ajustar ventanas y modelo con evidencia operativa.
- *Poner en otros usos:* reutilizar la arquitectura en manufactura, mantenimiento, depósitos u otros entornos que requieran supervisión remota.
- *Eliminar:* evitar el acoplamiento directo entre sensores y aplicaciones consumidoras, así como la dependencia exclusiva de revisiones manuales o umbrales únicos.
- *Reordenar o revertir:* analizar primero ventanas completas y después priorizar la inspección humana, en lugar de reaccionar únicamente a lecturas aisladas.

#figure(
	image(
		"../assets/arch-diagram.png",
		format: "png",
		width: 100%,
	),
	caption: [Los sensores de vibración, gas, fuego y nivel envían lecturas con marca de tiempo a un nodo Arduino, que las transmite por Wi‑Fi o Ethernet. Un cliente en Python valida y normaliza los datos, construye ventanas y aplica Isolation Forest para detectar anomalías. El broker MQTT coordina el intercambio y una base de series temporales conserva la información. Finalmente, una API/WebSocket distribuye actualizaciones al panel web, la aplicación móvil y el visor de realidad virtual, con protección TLS, autenticación y registro de actividad.],
)<arch-diagram>