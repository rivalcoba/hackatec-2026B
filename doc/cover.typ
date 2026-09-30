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

#let cover-group(label, body) = [
  #text(
    size: 8pt,
    weight: "bold",
    tracking: 1.15pt,
    fill: burgundy,
  )[#upper(label)]
  #v(0.5mm)
  #body
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
      rows: (45mm, 7mm, 1fr, 6mm),
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
      #grid(
        columns: (1fr,),
        // Espaciado entre el separador geométrico y el título.
        row-gutter: 8mm,
        align(center + horizon)[
          #cover-group("MEMORIA TÉCNICA", [
            #text(size: 8.5pt, weight: "medium", fill: muted)[
              #data.course · #data.course-code
            ]
          ])
        ],
        align(center + horizon)[
          #cover-group("TÍTULO Y SUBTÍTULO", [
            #par(leading: 0.98em, justify: false)[
              #text(
                size: 23pt,
                weight: "bold",
                fill: navy,
                hyphenate: false,
              )[#data.title]
            ]
            #v(2mm)
            #par(leading: 1.15em, justify: false)[
              #text(size: 10.5pt, fill: muted)[#data.subtitle]
            ]
          ])
        ],
        align(center + horizon)[
          #cover-group("RETO", [
            #text(size: 14pt, weight: "semibold", fill: navy)[#data.reto]
          ])
        ],
        align(center + horizon)[
          #cover-group("TEMÁTICA", [
            #text(size: 14pt, weight: "semibold", fill: navy)[#data.tematica]
          ])
        ],
        align(center + horizon)[
          #cover-group("PRESENTA", [
            #for student in data.students {
              student-entry(student)
              line(length: 100%, stroke: 0.35pt + line-gray)
            }
          ])
        ],
        align(center + horizon)[
          #cover-group("ASESOR", [
            #text(size: 14pt, weight: "semibold", fill: navy)[#data.professor]
          ])
        ],
        align(center + horizon)[
          #cover-group("FECHA DE ENTREGA", [
            #text(size: 14pt, weight: "semibold", fill: navy)[#data.date]
            #v(0.4mm)
            #text(size: 9.5pt, fill: muted)[#data.city · #data.period]
          ])
        ],
      )
    ],

      // Remate inferior sobrio.
      align(center + horizon)[
        #line(length: 34mm, stroke: 1pt + gold)
      ],
    )
  ]
]
