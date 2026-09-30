#import "styles.typ": burgundy, gold, line-gray, muted, navy

#let cover-entry(label, primary, secondary: none) = [
  #text(
    size: 8pt,
    weight: "bold",
    tracking: 1.15pt,
    fill: burgundy,
  )[#upper(label)]
  #v(0.5mm)
  #text(
    size: 14pt,
    weight: "semibold",
    fill: navy,
  )[#primary]
  #if secondary != none [
    #v(0.4mm)
    #text(
      size: 9.5pt,
      fill: muted,
    )[#secondary]
  ]
]

#let student-entry(student) = [
  #text(size: 9.2pt, weight: "semibold", fill: navy)[#student.name]
  #text(size: 8pt, fill: muted)[ · #student.program · #student.email]
]

#let cover(data) = page(
  paper: "a4",
  margin: 0pt,
  header: none,
  footer: none,
  fill: white,
)[
  #pad(left: 18mm, right: 18mm, top: 12mm, bottom: 12mm)[
    #grid(
      columns: (1fr,),
      rows: (45mm, 7mm, 56mm, 32mm, 80mm, 42mm, 7mm),
      row-gutter: 0pt,

      // Identidad institucional.
      align(center + horizon)[
        #image(
          "assets/logo-innovatec.png",
          width: 174mm,
          height: 44.2mm,
          fit: "contain",
        )
      ],

      // Separador geométrico que retoma el motivo tecnológico de la referencia.
      align(center + horizon)[
        #grid(
          columns: (1fr, 20mm, 1fr),
          column-gutter: 2mm,
          line(length: 100%, stroke: 0.7pt + gold),
          block(
            width: 20mm,
            height: 6mm,
            fill: navy,
          )[
            #align(center + horizon)[
              #text(size: 7pt, weight: "bold", fill: white)[TecNM ITGAM]
            ]
          ],
          line(length: 100%, stroke: 0.7pt + gold),
        )
      ],

      // Título y subtítulo.
      align(center + horizon)[
        #pad(left: 12mm, right: 12mm)[
          #text(
            size: 7.8pt,
            weight: "bold",
            tracking: 1.2pt,
            fill: burgundy,
          )[#upper(data.document-type)]

          #v(2mm)

          #text(
            size: 8.5pt,
            weight: "medium",
            fill: muted,
          )[#data.course · #data.course-code]

          #v(3mm)

          #par(leading: 0.98em, justify: false)[
            #text(
              size: 23pt,
              weight: "bold",
              fill: navy,
              hyphenate: false,
            )[#data.title]
          ]

          #v(2.5mm)

          #par(leading: 1.15em, justify: false)[
            #text(
              size: 10.5pt,
              fill: muted,
            )[#data.subtitle]
          ]
        ]
      ],

      // Reto y temática.
      align(center + horizon)[
        #cover-entry("RETO", data.reto)
        #v(2mm)
        #cover-entry("TEMÁTICA", data.tematica)
      ],

      // Lista de alumnos.
      align(center + horizon)[
        #cover-entry("PRESENTA", [
          #for student in data.students {
            student-entry(student)
            line(length: 100%, stroke: 0.35pt + line-gray)
          }
        ])
      ],

      // Asesor y fecha de entrega.
      align(center + horizon)[
        #cover-entry("ASESOR", data.professor)
        #v(2mm)
        #cover-entry(
          "FECHA DE ENTREGA",
          data.date,
          secondary: [#data.city · #data.period],
        )
      ],

      // Remate inferior sobrio.
      align(center + horizon)[
        #line(length: 34mm, stroke: 1pt + gold)
      ],
    )
  ]
]
