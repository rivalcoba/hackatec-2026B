#import "../styles.typ": muted, navy, pale-blue, paper

= Estructura de Costos Alternativa

== Escenario Lean Startup: primeros seis meses

PianiTech iniciará con 30 unidades comerciales y 10 equipos de demostración desde una cochera. El costo objetivo es \$1,500 por unidad y deberá validarse con una BOM.

El escenario lean difiere el pago de los fundadores. Odoo Personalizado para tres usuarios cuesta \$10,650 por seis meses; Odoo Estándar puede reducirlo a \$6,000 @odoo_pricing_2026. Meta recibe \$5,000 mensuales @meta_ads_costs_2026.

La cochera requiere adaptación, servicios, seguridad y mantenimiento. Deben verificarse uso de suelo, seguro, contrato eléctrico y tarifa PDBT @cfe_pdbt_2026. La SAS puede ser gratuita @gobmex_sas. El salario mínimo de 2026 orienta el escenario sostenible @conasami_salarios_2026.

La #link(<tabla-lean>)[Tabla 1] concentra los montos:

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
    [Inversión inicial], [Trámites, cochera, herramientas, piloto, inventario y empaque], [\$125,000],
    [Operación: 6 meses], [Odoo, Meta, infraestructura, servicios y soporte], [\$140,900],
    [Base], [Inversión inicial + operación], [\$265,900],
    [Contingencia], [10% para riesgos y pruebas], [\$26,590],
    text(weight: "bold")[Arranque lean], [Pago de fundadores diferido], text(weight: "bold")[\$292,490],
    [Escenario sostenible], [Lean + dos puestos y provisión patronal], [\$441,895],
  )
  #label("tabla-lean")
]

#v(2mm)
#align(center)[#text(size: 8.5pt, fill: muted)[Tabla 1. Resumen de costos del arranque lean.]]

== Control y decisión

Odoo integrará CRM, inventario, facturación y soporte; Meta captará prospectos. La pauta se liberará semanalmente y se medirán prospectos, conversión y margen. La producción crecerá solo con demanda validada. Precio mínimo: `costo directo / (1 − margen bruto objetivo)`.
