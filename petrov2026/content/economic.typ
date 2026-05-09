#import "../shared.typ": *

#num_head[
    Технико экономическое обоснование
]

#body_text[
    Для определения затрат составляется смета на покупку оборудования.
]

#let items = (
  (name: "Коммутационный шкаф Lanmaster", qty: 1, price: 24955),
  (name: "Патч-панель ExeGate", qty: 2, price: 2164),
  (name: "Маршрутизатор MikroTik RB5009UG+S+IN", qty: 1, price: 29750),
  (name: "Коммутатор PoE MikroTik CRS328-24P-4S+RM", qty: 1, price: 57499),
  (name: "Коммутатор MikroTik CRS326-24G-2S+RM", qty: 1, price: 31600),
  (name: "Видеорегистратор Hikvision DS-7616NI-Q2(D)", qty: 1, price: 14830),
  (name: "Жесткий диск HDD WD82PURX 8GB", qty: 2, price: 23340),
  (name: "ip-камера Hikvision Hikvision DS-2CD2183G2-IS", qty: 1, price: 12243),
  (name: "ip-камера Hikvision DS-2CD2143G2-IS", qty: 9, price: 9220),
  (name: "Точка доступа MikroTik cAP ax", qty: 5, price: 13264),
  (name: "ИБП CyberPower UT2200EG 1320ВТ", qty: 1, price: 12653),
  (name: "Бухта витой пары Cablexpert", qty: 2, price: 9999),
  (name: "Лестничный лоток LLZ200X50X2500(1.2)ZN", qty: 30, price: 565),
  (name: "MacBook Air 13 m2 16/256", qty: 11, price: 64990),
  (name: "MacBook Air 13 m3 24/512", qty: 23, price: 118990),
  (name: "Монитор DEXP DF24H1UC", qty: 34, price: 8500),
  (name: "Ноутбук OSiO FocusLine F140I-006", qty: 11, price: 34999),
)


// Считаем общую сумму через цикл
#let total_sum = items.map(it => it.qty * it.price).sum()


#gost_table(
  columns: (2.3fr, 0.4fr, 0.8fr, 0.7fr),
  rows: items.len() + 2, // +1 для заголовка, +1 для Итого
  [Наименование], [Кол-во], [Цена, руб.], [Сумма, руб.],

  // Генерируем строки автоматически
  ..items.map(it => (
    [#it.name],
    [#it.qty],
    [#it.price],
    [#(it.qty * it.price)]
  )).flatten(),

  // Финальная строка с авто-суммой
  table.cell(colspan: 3, align: left)[Итого:],
  [#total_sum]
)