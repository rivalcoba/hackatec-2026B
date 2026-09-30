#import "../styles.typ": muted, navy, pale-blue, paper

= Estructura de Costos Alternativa

== Escenario de arranque: primeros seis meses

La siguiente estructura representa un presupuesto de planeación para iniciar PianiTech en México con producción de baja escala en la cochera de un integrante, operación comercial automatizada con Odoo y captación de prospectos mediante Meta. Los importes están expresados en pesos mexicanos, incluyen una reserva prudencial y deben sustituirse por cotizaciones antes de comprometer recursos.

Se propone utilizar *Odoo Personalizado* para tres usuarios internos, porque incluye las aplicaciones y permite API externa para automatizar prospectos, pedidos o tickets. Su precio puede llegar a \$510 MXN por usuario al mes más IVA; por ello se presupuestan \$10,650 para seis meses. Odoo Estándar puede reducir el costo aproximadamente a \$6,000 sin integraciones externas @odoo_pricing_2026.

Meta permite definir la inversión y los límites de gasto de cada campaña. Se asignan \$5,000 mensuales durante seis meses, sujetos a revisión semanal según el costo por prospecto y la conversión @meta_ads_costs_2026.

== Supuestos de planeación

- Producción inicial de *30 unidades comerciales*, además de 10 equipos de demostración y piloto.
- Costo objetivo preliminar de materiales por unidad: *\$1,500 MXN*. Debe validarse mediante una BOM con proveedor, modelo, envío, impuestos, desperdicio y refacciones.
- La cochera no genera renta en efectivo durante los primeros seis meses, pero sí costos de adaptación, electricidad, internet, seguridad y mantenimiento.
- Deben verificarse el uso de suelo, el reglamento local, el seguro del inmueble y la compatibilidad de la actividad con el contrato eléctrico.
- Para baja tensión y demanda de hasta 25 kW, CFE publica la categoría PDBT; la tarifa y el depósito dependen de la región y la instalación @cfe_pdbt_2026.
- El presupuesto *lean* difiere temporalmente la remuneración de los fundadores. También se presenta un escenario sostenible con dos puestos de tiempo completo.
- El salario mínimo general de 2026 es de \$315.04 MXN diarios fuera de la Zona Libre de la Frontera Norte @conasami_salarios_2026.
- Una Sociedad por Acciones Simplificada puede constituirse en línea y sin costo si cumple sus requisitos; se conserva una reserva para asesoría, permisos y trámites @gobmex_sas.

== Inversión inicial

La #link(<tabla-inversion>)[Tabla 1] desglosa la inversión necesaria para preparar el espacio, adquirir herramientas y disponer del primer inventario.

#block[
  #set text(size: 7.8pt)
  #set table(inset: 1.5mm)
  #table(
    columns: (1.35fr, 2.7fr, 1fr),
    align: (left, left, right),
    fill: (x, y) => if y == 0 { navy } else if y == 8 { pale-blue } else if calc.odd(y) { paper } else { none },
    table.header(
      text(fill: white, weight: "bold")[Rubro],
      text(fill: white, weight: "bold")[Base de cálculo],
      text(fill: white, weight: "bold")[Monto (MXN)],
    ),
    [Constitución, alta fiscal y apertura administrativa], [Reserva para asesoría, e.firma, contratos, cuenta bancaria y revisión del esquema SAS], [\$10,000],
    [Propiedad intelectual], [Reserva para búsqueda y solicitud de marca, registro de software o documentación], [\$4,500],
    [Adaptación de la cochera], [Iluminación, ventilación, mesa, anaqueles, extintor, señalización y separación del inventario], [\$18,000],
    [Herramientas y control de calidad], [Estación de soldadura, extracción, protección ESD, multímetros, fuentes, crimpado, consumibles y patrones básicos de prueba], [\$28,000],
    [Equipos de demostración y piloto], [10 unidades × \$1,500], [\$15,000],
    [Inventario comercial inicial], [30 unidades × \$1,500], [\$45,000],
    [Empaque y etiquetado], [30 unidades × \$150], [\$4,500],
    text(weight: "bold")[Subtotal de inversión inicial], [], text(weight: "bold")[\$125,000],
  )
  #label("tabla-inversion")
]

#v(2mm)
#align(center)[#text(size: 8.5pt, fill: muted)[Tabla 1. Inversión inicial del escenario de arranque.]]

== Costos de operación durante seis meses

La #link(<tabla-operacion>)[Tabla 2] presenta los costos recurrentes estimados para operar durante los primeros seis meses.

#block[
  #set text(size: 7.8pt)
  #set table(inset: 1.5mm)
  #table(
    columns: (1.35fr, 2.7fr, 1fr),
    align: (left, left, right),
    fill: (x, y) => if y == 0 { navy } else if y == 11 { pale-blue } else if calc.odd(y) { paper } else { none },
    table.header(
      text(fill: white, weight: "bold")[Rubro],
      text(fill: white, weight: "bold")[Base de cálculo],
      text(fill: white, weight: "bold")[Monto para 6 meses (MXN)],
    ),
    [Odoo Personalizado], [3 usuarios × hasta \$510 × 6 meses × IVA, redondeado], [\$10,650],
    [Configuración de automatizaciones], [CRM, embudo, cotizaciones, inventario, facturación, posventa, garantías, tickets y tableros], [\$12,000],
    [Publicidad en Meta], [\$5,000 mensuales para campañas de generación de prospectos y remarketing], [\$30,000],
    [Infraestructura digital], [Dominio, correo, broker MQTT, servidor, base de datos, copias de seguridad y monitoreo], [\$9,000],
    [Electricidad e internet incremental], [\$2,000 mensuales para producción, pruebas y conectividad], [\$12,000],
    [Contabilidad y cumplimiento fiscal], [\$2,500 mensuales], [\$15,000],
    [Traslados, demostraciones e instalaciones], [\$5,000 mensuales], [\$30,000],
    [Consumibles y mantenimiento], [Soldadura, conectores, tornillería, filamento, adhesivos, limpieza y reposición de herramientas], [\$9,000],
    [Atención al cliente], [Telefonía, mensajería y número empresarial], [\$3,000],
    [Reserva de garantía], [5% del inventario comercial inicial], [\$2,250],
    [Seguridad, permisos y seguro], [Reserva para protección del espacio y responsabilidad civil], [\$8,000],
    text(weight: "bold")[Subtotal operativo], [], text(weight: "bold")[\$140,900],
  )
  #label("tabla-operacion")
]

#v(2mm)
#align(center)[#text(size: 8.5pt, fill: muted)[Tabla 2. Costos de operación durante seis meses.]]

== Capital requerido

La #link(<tabla-capital>)[Tabla 3] compara el capital requerido en un escenario lean y en un escenario sostenible con mano de obra presupuestada.

#block[
  #set text(size: 7.8pt)
  #set table(inset: 1.5mm)
  #table(
    columns: (1.4fr, 2.6fr, 1fr),
    align: (left, left, right),
    fill: (x, y) => if y == 0 { navy } else if y == 3 or y == 5 { pale-blue } else if calc.odd(y) { paper } else { none },
    table.header(
      text(fill: white, weight: "bold")[Escenario],
      text(fill: white, weight: "bold")[Cálculo],
      text(fill: white, weight: "bold")[Total (MXN)],
    ),
    [Base antes de contingencia], [Inversión inicial + operación de seis meses], [\$265,900],
    [Contingencia], [10% para inflación, importaciones, componentes defectuosos y repetición de pruebas], [\$26,590],
    text(weight: "bold")[Arranque lean en efectivo], [Trabajo de los fundadores temporalmente diferido], text(weight: "bold")[\$292,490],
    [Mano de obra para escenario sostenible], [Dos puestos × salario mínimo general × 30.4 días × 6 meses, más provisión patronal de 30%], [\$149,405],
    text(weight: "bold")[Arranque sostenible recomendado], [Arranque lean + mano de obra], text(weight: "bold")[\$441,895],
  )
  #label("tabla-capital")
]

#v(2mm)
#align(center)[#text(size: 8.5pt, fill: muted)[Tabla 3. Capital requerido según el escenario de operación.]]

*Advertencia:* el escenario *lean* no significa que el trabajo de los integrantes sea gratuito. Únicamente difiere su pago y debe registrarse como aportación de los socios. Si existe una relación laboral, la empresa deberá presupuestar salarios, seguridad social y prestaciones conforme a su ubicación y situación jurídica. La provisión patronal de 30% es un supuesto de planeación y no una tasa legal única.

== Automatización comercial y de posventa

El flujo recomendado es: *Anuncio o formulario de Meta → prospecto en Odoo CRM → calificación automática → cotización y seguimiento → pedido e inventario → instalación → factura → capacitación → ticket de soporte y garantía → encuesta de satisfacción.*

Odoo centralizaría ventas, inventario, contabilidad, proyectos y atención al cliente. Meta se utilizaría para captar prospectos y realizar remarketing. Los accesos deberán asignarse por función y las automatizaciones conservarán el consentimiento, la trazabilidad y únicamente los datos necesarios del cliente.

Durante el primer mes se configurarán:

- Catálogo de productos y servicios.
- Costos y listas de precios.
- Etapas del CRM y formularios de captación.
- Plantillas de correo y mensajería.
- Cotizaciones, recordatorios y políticas de garantía.
- Flujo de tickets de soporte y tableros de ventas y atención.

En los meses 2 y 3 se ejecutarán pruebas piloto, se medirá el costo real por unidad y se corregirá la BOM. En los meses 4 a 6 se liberará la producción comercial mediante lotes pequeños, únicamente cuando exista demanda confirmada o se alcance el nivel mínimo de inventario, para evitar inmovilizar efectivo.

== Control financiero y criterios de decisión

- Separar los gastos personales y empresariales desde el primer día.
- Registrar las horas de ensamble, pruebas, instalación y soporte, aunque los socios difieran su pago.
- Liberar la pauta de Meta por bloques semanales y detener anuncios que no generen prospectos calificados.
- Medir costo por prospecto, conversión a demostración, conversión a venta, margen bruto, devoluciones, tiempo de instalación y tickets por equipo.
- Mantener un fondo de garantía separado e inventario mínimo de refacciones críticas.
- Solicitar cotizaciones comparables para fabricar 10, 30 y 100 unidades.
- Dividir la compra de las primeras 30 unidades en dos lotes si la BOM o la demanda todavía no han sido validadas.
- No fijar el precio comercial únicamente con base en el costo de los componentes.

El costo directo unitario debe incluir:

1. Lista de materiales.
2. Envíos e impuestos.
3. Empaque.
4. Merma.
5. Ensamble.
6. Pruebas.
7. Comisiones.
8. Instalación.
9. Capacitación.
10. Garantía.
11. Soporte inicial.

El precio mínimo puede calcularse mediante la fórmula `Precio = costo directo / (1 − margen bruto objetivo)`.
