#import "../styles.typ": muted, navy, pale-blue, paper

= Estructura de Costos Alternativa

== Escenario Lean Startup: primeros seis meses

PianiTech iniciará con producción de baja escala desde la cochera de un integrante, 30 unidades comerciales y 10 equipos de demostración o piloto. El costo objetivo de materiales es de \$1,500 por unidad y deberá validarse con una BOM que incluya proveedor, envío, impuestos, desperdicio y refacciones.

El escenario lean difiere temporalmente el pago de los fundadores. Odoo Personalizado para tres usuarios se estima en \$10,650 por seis meses; Odoo Estándar podría reducirlo a aproximadamente \$6,000 @odoo_pricing_2026. Se reservan \$5,000 mensuales para Meta, sujetos a revisión semanal según prospectos y conversiones @meta_ads_costs_2026.

La cochera no genera renta, pero requiere adaptación, electricidad, internet, seguridad y mantenimiento. Deben verificarse uso de suelo, seguro, contrato eléctrico y la categoría PDBT de CFE @cfe_pdbt_2026. La constitución SAS puede ser gratuita, aunque se reserva presupuesto para asesoría y trámites @gobmex_sas; el salario mínimo general de 2026 sirve como referencia para el escenario sostenible @conasami_salarios_2026.

La #link(<tabla-lean>)[Tabla 1] concentra los montos de decisión:

#block[
  #set text(size: 8pt)
  #set table(inset: 1.5mm)
  #table(
    columns: (2fr, 2.7fr, 1fr),
    align: (left, left, right),
    fill: (x, y) => if y == 0 { navy } else if y == 6 or y == 8 { pale-blue } else if calc.odd(y) { paper } else { none },
    table.header(
      text(fill: white, weight: "bold")[Bloque],
      text(fill: white, weight: "bold")[Alcance],
      text(fill: white, weight: "bold")[Monto (MXN)],
    ),
    [Inversión inicial], [Constitución, propiedad intelectual, cochera, herramientas, piloto, inventario y empaque], [\$125,000],
    [Operación: 6 meses], [Odoo, automatizaciones, Meta, infraestructura, servicios, contabilidad, traslados, mantenimiento y garantía], [\$140,900],
    [Base antes de contingencia], [Inversión inicial + operación], [\$265,900],
    [Contingencia], [10% para inflación, importaciones y repetición de pruebas], [\$26,590],
    text(weight: "bold")[Arranque lean], [Fundadores difieren temporalmente su remuneración], text(weight: "bold")[\$292,490],
    [Escenario sostenible], [Arranque lean + dos puestos y provisión patronal de 30%], [\$441,895],
  )
  #label("tabla-lean")
]

#v(2mm)
#align(center)[#text(size: 8.5pt, fill: muted)[Tabla 1. Resumen de costos del arranque lean.]]

== Control y decisión

Odoo integrará CRM, inventario, facturación, posventa y tickets; Meta captará prospectos. Se liberará la pauta por bloques semanales y se medirá costo por prospecto, conversión, margen, instalación, garantía y soporte. La producción crecerá solo con demanda validada. El precio mínimo se estimará como `costo directo / (1 − margen bruto objetivo)`.
