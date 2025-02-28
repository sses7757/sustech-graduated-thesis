#import "../utils/datetime-display.typ": datetime-display, datetime-en-display, datetime-display-upper
#import "../utils/justify-text.typ": justify-text
#import "../utils/style.typ": 字号, 字体
#import "../utils/degree-names.typ": degree-types

// 硕士研究生封面
#let final-cover(
  // documentclass 传入的参数
  degree: "MEng",
  academic: true,
  nl-cover: false,
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  info-inset: (x: 0pt, bottom: 0.5pt),
  info-key-width: 86pt,
  info-column-gutter: 18pt,
  info-row-gutter: 12pt,
  meta-block-inset: (left: -15pt),
  meta-info-inset: (x: 0pt, bottom: 2pt),
  meta-info-key-width: 35pt,
  meta-info-column-gutter: 10pt,
  meta-info-row-gutter: 1pt,
  defense-info-inset: (x: 0pt, bottom: 0pt),
  defense-info-key-width: 110pt,
  defense-info-column-gutter: 2pt,
  defense-info-row-gutter: 12pt,
  anonymous-info-keys: (
    "student-id",
    "author",
    "author-en",
    "supervisor",
    "supervisor-en",
    "supervisor-ii",
    "supervisor-ii-en",
    "chairman",
    "reviewer",
  ),
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    (
      title: ("基于Typst的", "南方科技大学学位论文"),
      grade: "20XX",
      student-id: "1234567890",
      author: "张三",
      department: "某系",
      major: "某专业",
      supervisor: ("李四", "教授"),
      submit-date: datetime.today(),
      defend-date: datetime.today(),
      bottom-date: datetime.today(),
    )
      + info
  )

  // 2.  对参数进行处理
  if type(info.title) == array {
    info.title = info.title.sum()
  }
  if type(info.title-en) == array {
    info.title-en = info.title-en.sum()
  }
  info.degree = degree-types.at(degree)

  // 3.  内置辅助函数
  let info-key(body, info-inset: info-inset, is-meta: false) = {
    set text(
      font: if is-meta { fonts.宋体 } else { fonts.楷体 },
      size: if is-meta { 字号.小五 } else { 字号.三号 },
      weight: if is-meta { "regular" } else { "bold" },
    )
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      justify-text(with-tail: is-meta, body),
    )
  }

  let info-value(key, body, info-inset: info-inset, is-meta: false, no-stroke: false) = {
    set align(center)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: if no-stroke { none } else { (bottom: stoke-width + black) },
      text(
        font: if is-meta { fonts.宋体 } else { fonts.楷体 },
        size: if is-meta { 字号.小五 } else { 字号.三号 },
        bottom-edge: "descender",
        if (anonymous and (key in anonymous-info-keys)) {
          if is-meta { "█████" } else { "██████████" }
        } else {
          body
        },
      ),
    )
  }

  let anonymous-text(key, body) = {
    if (anonymous and (key in anonymous-info-keys)) {
      "██████████"
    } else {
      body
    }
  }

  let meta-info-key = info-key.with(info-inset: meta-info-inset, is-meta: true)
  let meta-info-value = info-value.with(info-inset: meta-info-inset, is-meta: true)
  let defense-info-key = info-key.with(info-inset: defense-info-inset)
  let defense-info-value = info-value.with(info-inset: defense-info-inset)


  // 4.  正式渲染

  // 居中对齐
  set align(center)
  set par(first-line-indent: (amount: 0pt, all: true))

  // 4.1 封面页
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    align: top + center,
    columns: 1,
    rows: (2cm, 1.38cm, 2cm, 3cm, 4cm, 3cm),
    [],
    [
      #set par(spacing: 0.5em, leading: 0.75em)
      #set text(size: 字号.小一, font: fonts.宋体, weight: "bold")
      #let t = (
        (if degree == "PhD" { "博士" } else { "硕士" }) + (if academic { "" } else { "专业" }) + "学位论文"
      )
      #t
    ],

    [],
    [
      #set text(size: 字号.二号, font: fonts.黑体)
      #info.title
    ],

    [
      #set text(size: 字号.小二, font: fonts.宋体, weight: "bold")
      #upper(info.title-en)
    ],

    [],
  )
  set text(size: 字号.小二, font: fonts.宋体)
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: (3.33cm, 3.8cm, 0.05cm, 0.82cm, 1fr),
    rows: (1cm, 1cm),
    align: left,
    [], [#justify-text("研究生", split-by: "")], [], [：], info.author,
    [], [#justify-text("指导教师", split-by: "")], [], [：], info.supervisor.join(),
  )
  grid(
    align: top,
    columns: 1,
    rows: (2cm, 1.24cm, 1.24cm),
    [],
    [南方科技大学],
    [#datetime-display-upper(info.defend-date)],
  )
  pagebreak(to: "odd")

  // 4.2 中文题名页
  set text(size: 字号.小四, font: fonts.宋体, weight: "regular")
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: 1,
    rows: (字号.小四 * 1.25, 字号.小四 * 1.25),
    [国内图书分类号：#info.clc #h(1fr) 学校代码：#info.school-code],
    [国际图书分类号：#info.udc #h(1fr) 密级：#info.secret-level~~],
  )
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: 1,
    align: top,
    rows: (3.5cm, 1cm, 1cm, 3cm, 5.27cm),
    [],
    [
      #set text(size: 字号.小二, font: fonts.宋体, weight: "bold")
      #(
        if academic { info.degree.at(0) } else {
          info.major-short + if info.degree.at(0).contains("硕士") { "硕士" } else { "博士" }
        }
          + "学位论文"
      )
    ],

    [],
    [
      #set text(size: 字号.二号, font: fonts.黑体, weight: "regular")
      #info.title
    ],

    [],
  )
  set text(size: 字号.四号, font: fonts.宋体)
  let distr = justify-text.with(split-by: "", text-args: (font: fonts.黑体))
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: (3.85cm, 3.1cm, 0.09cm, 0.53cm, 1fr),
    rows: (1cm, 1cm),
    align: left,
    [], [#distr("学位申请人")], [], [：], info.author,
    [], [#distr("指导教师")], [], [：], info.supervisor.join(),
    ..(
      if info.supervisor-ii != () {
        ([], [], [], [], info.supervisor-ii.join())
      } else { () }
    ),
    [], [#distr(if academic { "学科名称" } else { "专业类别" })], [], [：], info.major,
    [], [#distr("答辩日期")], [], [：], datetime-display(info.defend-date),
    [], [#distr("培养单位")], [], [：], info.department,
    [], [#distr("学位授予单位")], [], [：], [南方科技大学],
  )

  // 4.3 英文题名页
  set text(size: 字号.三号, font: fonts.宋体, weight: "regular")
  set par(leading: 1em, spacing: 1.5em)
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: 1,
    align: top,
    rows: (字号.一号 * 1.2, 8.26cm - 字号.一号 * 1.2, 4.75cm, 2.75cm, 3cm),
    [],
    [
      #set text(size: 字号.二号, font: fonts.宋体, weight: "bold")
      #upper(info.title-en)
    ],

    [
      A dissertation submitted to \
      Southern University of Science and Technology \
      in partial fulfillment of the requirement \
      for the degree of \
      #if academic { info.degree.at(1) } else {
        if info.degree.at(0).contains("硕士") { "Master of " } else { "Doctor of " } + info.major-en-short
      }
    ],

    if academic [
      in \
      #info.major-en
    ] else [],

    [
      by \
      #info.author-en
    ],
  )
  grid(
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: (0.7fr, 0.75cm, 1fr),
    rows: (1.23cm, 1.23cm, 0.49cm, 0.5cm),
    align: (right, left, left),
    [Supervisor], [~:], info.supervisor-en,
    ..(
      if info.supervisor-ii != () {
        ([Associate Supervisor], [~:], info.supervisor-ii-en)
      } else { ([], [], []) }
    ),
    grid.cell(colspan: 3)[],
    grid.cell(colspan: 3, align: center)[#datetime-en-display(info.defend-date)],
  )
  pagebreak(weak: true)

  // 4.3 评阅人
  set text(font: fonts.黑体, size: 字号.三号)
  set par(leading: 1em, spacing: 1em)
  v(24pt)
  [学位论文公开评阅人和答辩委员会名单]
  v(18pt)
  set text(font: fonts.黑体, size: 字号.四号)
  v(24pt)
  [公开评阅人名单]
  v(6pt)

  set text(font: fonts.宋体, size: 字号.小四)
  grid(
    align: center,
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: (19.8%, 19.8%, 68.5%),
    rows: 20pt,
    [刘XX], [教授], [南方科技大学],
    [陈XX], [副教授], [XXXX大学],
    [杨XX], [研究员], [中国XXXX科学院XXXXXXX研究所],
  )

  set text(font: fonts.黑体, size: 字号.四号)
  v(24pt)
  [答辩委员会名单]
  v(6pt)

  set text(font: fonts.宋体, size: 字号.小四)
  grid(
    align: center,
    gutter: 0pt,
    column-gutter: 0pt,
    row-gutter: 0pt,
    columns: (18.3%, 19.8%, 29.5%, 32.2%),
    rows: 20pt,
    [主席], [赵 XX], [教授], [南方科技大学],
    [委员], [刘 XX], [教授], [南方科技大学],
    [], [杨 XX], [研究员], [中国 XXXX 科学院],
    [], [黄 XX], [教授], [XXXXXX 研究所],
    [], [周 XX], [副教授], [XXXX 大学],
    [秘书], [吴 XX], [助理研究员], [南方科技大学],
  )
}
