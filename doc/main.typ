#import "data.typ": report
#import "styles.typ": document-style
#import "cover.typ": cover

// Configuración general del documento.
#show: body => document-style(report, body)

// Portada institucional.
#cover(report)

// El cuerpo comienza en una página nueva y reinicia su numeración.
#pagebreak()
#counter(page).update(1)

// Resumen e índice.
#include "sections/00-resumen.typ"
#pagebreak()

#outline(
  title: [Contenido],
  depth: 3,
  indent: 8mm,
)
#pagebreak()

// Estructura de la propuesta.
#include "sections/01-problema.typ"
#include "sections/02-propuesta.typ"
#include "sections/03-metodologia.typ"
#include "sections/04-herramientas.typ"
#include "sections/05-especificacion.typ"
#include "sections/06-ejes.typ"
#include "sections/07-modelo-negocio.typ"
#include "sections/08-validacion.typ"
#include "sections/09-costos.typ"

// Bibliografía.
#pagebreak()
#bibliography(
  "referencias.bib",
  title: [Referencias],
  style: "ieee",
)
