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


#let pic-cache = state("pic-cache", none)

#let pic_cap(cache-key) = {
  context {
    let cache = state(cache-key, none).get()

    if cache != none {
      cache
    } else {
      // Получаем текущие значения (массивы)
      let intro_vals = intro-counter.at(here())
      let image_vals = image-counter.at(here())

      // Берем первое число из массива и прибавляем 1
      let intro_num = intro_vals.first()
      let image_num = image_vals.first() + 1

      let result = [#intro_num.#image_num.]

      // Шагаем счетчик, чтобы СЛЕДУЮЩИЙ вызов видел правильное число
      image-counter.step()

      // Записываем в кэш
      state(cache-key, none).update(result)
      result
    }
  }
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
  set par(leading: 1em)   // межстрочный интервал для абзацев
  set list(
    marker: [---],
    indent: 1.25cm,
    body-indent: 0.4cm,
    spacing: 1em            // отступ между пунктами списка
  )
  txt
}


#let gost_table(
  columns: (auto, 1fr),  // значение по умолчанию
  rows: 1,
  caption: none,
  ..args
) = {
  table(
    columns: columns,
    inset: (x: 0.6em, y: 0.6em),
    stroke: (x, y) => (
      left: 1pt,
      right: 1pt,
      top: if y == 0 { 1pt } else { none },           // верхняя граница
      bottom: if y == rows - 1 { 1pt } else if y == 0 { 1pt } else { 1pt }  // разделительные линии между строками и нижняя
    ),
    align: (x, y) => {
      if y == 0 { center } else { left }
    },
    ..args
  )
}