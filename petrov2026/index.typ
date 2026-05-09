#set page(
  paper: "a4",
  margin: (
    top: 2cm,
    bottom: 2cm,
    left: 3cm,
    right: 1.5cm
  )
)


#set text(font: "Times New Roman", size: 14pt, lang: "ru")
#set list(indent: 1.5em)

#set page(
  footer: context {
    let page_num = counter(page).at(here()).first()

    if page_num >= 4 {
      // Настройки текста для номера страницы
      set text(fill: rgb(0, 0, 0, 50%), size: 14pt)
      align(center)[#page_num]
    }
  }
)

// ------------------------

#include "./content/title.typ"
#pagebreak()

#include "./content/task.typ"
#pagebreak()

#include "./content/toc.typ"
#pagebreak()

#include "./content/intro.typ"
#pagebreak()

#include "./content/theory.typ"
#pagebreak()

#include "./content/zone_description.typ"
#pagebreak()

#include "./content/lvs.typ"
#pagebreak()

#include "./content/equipment.typ"
#pagebreak()

#include "./content/configure.typ"
#pagebreak()

#include "./content/economic.typ"
#pagebreak()