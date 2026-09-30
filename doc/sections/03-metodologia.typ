= Metodología de desarrollo

El desarrollo sigue un proceso incremental (@fig-metodologia-pianitech) orientado a evidencia:

1. *Delimitar el activo y la variable:* identificar máquina, área o depósito; definir unidad, frecuencia de muestreo y condición esperada.
2. *Instrumentar:* instalar el sensor mediante *retrofitting* y asociarlo con identificadores de taller, activo y dispositivo.
3. *Adquirir y publicar:* generar mensajes con lectura y marca de tiempo; publicarlos en la jerarquía MQTT correspondiente.
4. *Recibir y validar:* suscribir el cliente Python, comprobar estructura y tipos, y registrar mensajes inválidos sin interrumpir el servicio.
5. *Organizar:* separar los datos por activo, variable y tiempo; detectar ausencia de información.
6. *Construir ventanas:* agrupar lecturas por intervalos y extraer características representativas de cada proceso.
7. *Analizar:* entrenar o ajustar *Isolation Forest* con ventanas apropiadas y evaluar nuevas observaciones.
8. *Verificar:* ejecutar pruebas de publicación, recepción, simultaneidad, pérdida de comunicación, construcción de ventanas y detección de comportamientos atípicos.
9. *Reportar y mejorar:* presentar estados, anomalías y datos de origen; revisar resultados para ajustar sensores, ventanas y modelo.

#set text(font: "Noto Sans", size: 9pt)

#let color-principal = rgb("#4C6FAF")
#let color-analisis = rgb("#E6F4EA")
#let color-verificacion = rgb("#FFF4E5")
#let color-reporte = rgb("#FCE8E6")

#let etapa(contenido, color: rgb("#E8F0FE")) = box(
  width: 30mm,
  height: 15mm,
  fill: color,
  stroke: 0.8pt + color-principal,
  radius: 4pt,
  inset: 4pt,
  align(center + horizon)[
    #text(size: 8.5pt, weight: "semibold")[#contenido]
  ],
)

#let flecha-derecha = text(
  size: 14pt,
  fill: color-principal,
)[→]

#let flecha-izquierda = text(
  size: 14pt,
  fill: color-principal,
)[←]

#let flecha-abajo = text(
  size: 14pt,
  fill: color-principal,
)[↓]

#figure(
  supplement: [Figura],
  align(center)[
    #grid(
      columns: (
        30mm, 8mm, 30mm, 8mm,
        30mm, 8mm, 30mm,
      ),
      column-gutter: 2pt,
      row-gutter: 5pt,
      align: center + horizon,

      // Primera fila
      etapa([Delimitar]),
      flecha-derecha,
      etapa([Instrumentar]),
      flecha-derecha,
      etapa([Adquirir y publicar]),
      flecha-derecha,
      etapa([Recibir y validar]),

      // Conexión hacia la segunda parte
      [],
      [],
      [],
      [],
      [],
      [],
      flecha-abajo,

      // Segunda fila: el flujo continúa de derecha a izquierda
      etapa(
        [Verificar],
        color: color-verificacion,
      ),
      flecha-izquierda,
      etapa(
        [Analizar],
        color: color-analisis,
      ),
      flecha-izquierda,
      etapa([Construir ventanas]),
      flecha-izquierda,
      etapa([Organizar]),

      // Conexión hacia la etapa final
      flecha-abajo,
      [],
      [],
      [],
      [],
      [],
      [],

      // Etapa final
      etapa(
        [Reportar y mejorar],
        color: color-reporte,
      ),
      [],
      [],
      [],
      [],
      [],
      [],
    )
  ],
  caption: [
    Metodología incremental para el desarrollo y la validación de PianiTech.
  ],
) <fig-metodologia-pianitech>