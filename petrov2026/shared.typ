#let toc-state = state("toc-state", ())

#let make_toc() = context {
  let entries = toc-state.final()

  set par(spacing: 0.5em)

  for entry in entries {
    // ВОТ ЭТА ПРОВЕРКА: если заголовок (в любом регистре) это "СОДЕРЖАНИЕ" — пропускаем
    if upper(entry.title) == "СОДЕРЖАНИЕ" {
      continue
    }

    let indent = if entry.level == 1 { 0pt } else { 0.65cm }

    pad(left: indent)[
      #table(
        columns: (1fr, auto),
        inset: 0pt,
        stroke: none,
        align: bottom,

        [
          #set par(leading: 0em)
          #if entry.number != none [#entry.number. ] #entry.title
          #box(width: 1fr, h(0.3em) + repeat[.])
        ],

        [#entry.page],
      )
    ]
  }
}


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

  context {
    let loc = here()

    toc-state.update(old => old + (
      (
        level: 1,
        number: none,
        title: upper(txt),
        page: counter(page).at(loc).first(),
      ),
    ))

    [#h(1.25cm)] + upper(txt)   // ← добавил отступ слева
  }
}

#let center_head(txt, in_toc: true) = {
  set par(
    leading: 0.65em,
    justify: false,
    spacing: 0.65em,
  )
  set text(
    lang: "ru",
    hyphenate: true,
  )

  context {
    let loc = here()

    // Добавляем в state только если in_toc == true
    if in_toc {
      toc-state.update(old => old + (
        (
          level: 1,
          number: none,
          title: upper(txt),
          page: counter(page).at(loc).first(),
        ),
      ))
    }

    align(center)[
      #h(0pt)#upper(txt)
    ]
  }
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
  sub-counter.update(0)
  image-counter.update(0)
  table-counter.update(0)

  context {
    let num = intro-counter.display()

    // Создаем метку
    let loc = here()

    // Добавляем запись в TOC
    toc-state.update(old => old + (
      (
        level: 1,
        number: num,
        title: upper(txt),
        page: counter(page).at(loc).first(),
      ),
    ))

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

    let full_num = main_num + "." + sub_num

    let loc = here()

    toc-state.update(old => old + (
      (
        level: 2,
        number: full_num,
        title: txt,
        page: counter(page).at(loc).first(),
      ),
    ))

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
    // Оставляем это на случай, если внутри txt будет несколько абзацев
    leading: 1em,
    justify: true,
    spacing: 1em,
  )
  set text(
    lang: "ru",
    hyphenate: true,
  )

  // Убираем [#h(0pt)] и жестко вставляем пробел в 1.25cm для первой строки.
  // Это заставит Typst нарисовать красную строку даже сразу после списка.
  h(1.25cm) + txt
}

#let dash_list(txt) = {
  // Настраиваем правила для абзацев внутри этого блока
  set par(
    first-line-indent: 1.25cm, // Только первая строка сдвигается на 1.25cm
    leading: 1em,
    justify: true,
    spacing: 1em
  )

  // Перехватываем стандартный список и превращаем его в текст
  show list: it => {
    it.children.map(item => {
      // Собираем строку: тире + отступ 0.2cm + текст пункта
      [--- #h(0.1cm) #item.body]
    }).join(parbreak()) // parbreak() делает каждый пункт отдельным абзацем
  }

  txt
}

#let num_list(txt) = {
  set enum(
    indent: 0pt,         // Номер стоит у левого края
    body-indent: 0.4cm,  // Расстояние от номера до текста
    spacing: 1em,
    numbering: "1.",
  )

  set par(
    first-line-indent: 1.25cm, // Красная строка для первой линии (где номер)
    hanging-indent: 0pt,       // Вторая строка пойдет от нуля (левого края)
    justify: true,
    leading: 1em,
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