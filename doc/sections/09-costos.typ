#import "../styles.typ": muted, navy, pale-blue, paper

= Proyección de costos

La estimación financiera de PianiTech se plantea como un proceso gradual que acompaña a la tecnología desde la validación del prototipo hasta su comercialización o transferencia. La primera etapa corresponde a un lote piloto de 10 unidades para comprobar adquisición, comunicación MQTT, almacenamiento, construcción de ventanas y detección de anomalías. La segunda etapa consolida el diseño, la lista de materiales, los tiempos de ensamble, la instalación y la documentación. La tercera incorpora los recursos necesarios para producir, proteger, empaquetar, promover, distribuir, capacitar y dar soporte a la solución.

El presupuesto distingue entre *costos preliminares disponibles*, *actividades sin desembolso inicial* y *rubros pendientes de investigación o cotización*. Esta separación evita presentar como inversión definitiva un subtotal que todavía no incluye todos los recursos requeridos.

== Presupuesto preliminar para el lote piloto

La #link(<tabla-presupuesto>)[Tabla 1] presenta una estimación inicial de los recursos necesarios para producir y validar el lote piloto de PianiTech. Los montos cuantificados corresponden a los costos disponibles al momento del análisis, mientras que los rubros pendientes requieren cotizaciones, mediciones o una definición más precisa del alcance.

#block[
	#set text(size: 7.5pt)
	#set table(inset: 1.5mm)
	#table(
		columns: (1.15fr, 2.3fr, 1fr, 2.55fr),
		align: (left, left, right, left),
		fill: (x, y) => if y == 0 {
			navy
		} else if y == 14 {
			pale-blue
		} else if calc.odd(y) {
			paper
		} else {
			none
		},
		table.header(
			text(fill: white, weight: "bold")[Rubro],
			text(fill: white, weight: "bold")[Base de estimación y alcance],
			text(fill: white, weight: "bold")[Monto estimado (MXN)],
			text(fill: white, weight: "bold")[Evidencia o información pendiente],
		),
		[Producción y escalamiento],
		[Estimación existente para 10 placas PCB, componentes al mayoreo y filamento PLA para gabinetes 3D],
		[\$3,500],
		[Obtener la lista de materiales con fabricante, modelo, cantidad y precio; cargar los archivos Gerber, BOM y CPL para solicitar una cotización reproducible de PCB y ensamble. El fabricante consultado genera cotizaciones con esos archivos @jlcpcb_fabricacion_pcb.],
		[Infraestructura digital],
		[Broker MQTT, almacenamiento de telemetría, respaldo, conectividad y equipo de cómputo],
		[Pendiente],
		[Definir mensajes por minuto, retención histórica, disponibilidad, número de dispositivos y si el despliegue será local o en la nube; después, cotizar el escenario elegido.],
		[Desarrollo y pruebas],
		[Integración electrónica, cliente Python, calibración, pruebas funcionales, pruebas de comunicación y ejecución del piloto],
		[Pendiente],
		[Registrar las horas de trabajo por actividad, los materiales consumibles, el uso de laboratorio y el costo de repetir las pruebas.],
		[Propiedad intelectual],
		[Registro de obra o programa de computación ante INDAUTOR],
		[\$367],
		[La tarifa oficial de 2026 para el registro de una obra es de \$367 MXN @indautor_tarifas_2026. Falta determinar si también se protegerán el nombre comercial, la marca, el diseño o alguna invención mediante trámites diferentes.],
		[Certificaciones y cumplimiento],
		[Autoevaluación, evaluación de riesgos e informes internos durante la validación escolar],
		[\$0 en la fase interna],
		[Identificar las normas aplicables cuando se definan los sensores, la alimentación, el gabinete, las comunicaciones y la instalación; solicitar una cotización a un laboratorio acreditado si se requiere una certificación externa. La validación interna no equivale a una certificación.],
		[Empaquetado],
		[Estimación existente para cajas Kraft, etiquetas y código QR hacia el manual digital del lote piloto],
		[\$500],
		[Obtener una cotización que considere las medidas del gabinete, la cantidad, la impresión, los impuestos y la entrega.],
		[Promoción],
		[Estimación existente para materiales de demostración y difusión inicial],
		[\$300],
		[Precisar los impresos, traslados, demostraciones y dominio. GitHub ofrece un plan gratuito con Pages para documentación o un sitio sencillo, por lo que la plataforma puede comenzar sin una cuota de hospedaje dentro de sus límites @github_pricing_2026.],
		[Distribución],
		[Estimación existente para entregas locales o primeros envíos],
		[\$600],
		[Medir el peso y las dimensiones del paquete, además de definir origen, destino, seguro y volumen. El costo debe comprobarse mediante el tarificador oficial de MEXPOST o cotizaciones equivalentes @mexpost_tarificador.],
		[Instalación],
		[Diagnóstico del sitio, traslado, montaje, configuración, pruebas de recepción y puesta en operación],
		[Pendiente],
		[Definir la distancia, duración, personal, materiales de fijación, alimentación y condiciones de cada activo.],
		[Capacitación],
		[Manual en PDF, videotutoriales y sesión inicial elaborados por el equipo],
		[\$0 de desembolso inicial],
		[Estimar las horas de preparación, la duración por cliente, la actualización de los materiales y la modalidad presencial o remota.],
		[Licenciamiento],
		[Uso previsto de componentes de código abierto],
		[\$0 de desembolso inicial],
		[Elegir la licencia del software propio, revisar su compatibilidad con las dependencias y definir qué se transfiere al cliente: uso, código, documentación, datos o servicio.],
		[Soporte técnico],
		[Atención inicial mediante correo y mensajería administrada por el equipo],
		[\$0 de desembolso inicial],
		[Definir la garantía, horario, canal, tiempo de respuesta, mantenimiento, reposición y horas mensuales; estas horas deberán convertirse en un costo operativo.],
		[Contingencia],
		[Reposición de componentes, variaciones de precio y repetición de pruebas],
		[Pendiente],
		[Definir el monto después de recibir las cotizaciones y evaluar los riesgos del piloto.],
		text(weight: "bold")[Subtotal preliminar cuantificado],
		text(weight: "bold")[Producción, propiedad intelectual, empaquetado, promoción y distribución],
		text(weight: "bold")[\$5,267],
		text(weight: "bold")[No incluye infraestructura, desarrollo, certificación externa, instalación, horas de capacitación, soporte ni contingencia.],
  )
	#label("tabla-presupuesto")
]

#v(2mm)
#align(center)[
	#text(size: 8.5pt, fill: muted)[
		Tabla 1. Presupuesto preliminar cuantificado para el lote piloto.
	]
]
