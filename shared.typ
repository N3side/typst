#let head(txt) = {
  set par(
    first-line-indent: 1.25cm,
    leading: 0.65em,
    justify: true,
    spacing: 0.65em,
  )
  set text(
    lang: "ru",
    hyphenate: true,
  )

  show text: upper

  [#h(0pt)] + txt
}

#let intro-counter = counter("intro-head")
#let sub-counter = counter("sub-head")
#let image-counter = counter("image-counter")
#let table-counter = counter("image-counter")

// 2. Функция для основных заголовков (1. ЗАГОЛОВОК)
#let num_head(txt) = {
  set par(first-line-indent: 0pt, leading: 1em, justify: true, spacing: 1em)
  set text(lang: "ru", hyphenate: true)

  intro-counter.step()
  sub-counter.update(0) // Сбрасываем подпункты
  image-counter.update(0)   // Сбрасываем счётчик изображений
  table-counter.update(0)   // Сбрасываем счётчик изображений

  context {
    let num = intro-counter.display()
    h(1.25cm) + num + [#". "] + upper(txt)
  }
}

// 3. Функция для подзаголовков (1.1. Заголовок)
#let num_sub_head(txt) = {

  set par(first-line-indent: 0pt, leading: 0.65em, justify: true, spacing: 0.65em)
    set text(lang: "ru", hyphenate: true)

  sub-counter.step()

  context {
    let main_num = intro-counter.display()
    let sub_num = sub-counter.display()
    // Собираем строку номера: "1.1. "
    h(1.25cm) + main_num + "." + sub_num + ". " + txt
  }
}

#let num_center_head(txt) = {

  set par(
      leading: 0.65em,
      justify: true,
      spacing: 0.65em,
    )

  set text(lang: "ru", hyphenate: true)

  intro-counter.step()

  context {
    let num = intro-counter.display()

    align(center)[
      #set par(leading: 0.65em, justify: false)
      #num. #upper(txt)
    ]
  }
}

#let center_head(txt) = {
  set par(
    leading: 0.65em,
    justify: false,
    spacing: 0.65em,
  )
  set text(
    lang: "ru",
    hyphenate: true,
  )

  show text: upper

  align(center)[
    #h(0pt)#txt
  ]
}



#let pic_cap(txt) = {
  image-counter.step()

  context [
    #set text(hyphenate: false)
    Рисунок #intro-counter.display().#image-counter.display(). #txt
  ]
}

#let table_cap(txt) = {
  image-counter.step()

  context [
    #set text(hyphenate: false)
    Рисунок #intro-counter.display().#table-counter.display(). #txt
  ]
}

#let body_text(txt) = {
  set par(
    first-line-indent: 1.25cm,
    leading: 1em,
    justify: true,
    spacing: 1em,
  )
  set text(
    lang: "ru",
    hyphenate: true,
  )

  [#h(0pt)] + txt
}

#let dash_list(txt) = {
  set list(
    marker: [---],
    indent: 1.25cm,      // отступ слева для всех строк
    body-indent: 0.4cm,  // дополнительный отступ для второй и последующих строк
    spacing: 1em
  )
  txt
}