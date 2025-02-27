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

  // 4.1 封面页
  grid(
    align: top,
    columns: 1,
    rows: (2cm, 1.38cm, 2cm, 3cm, 4cm, 3cm),
    [],
    [
      #set par(spacing: 0.5em, leading: 0.75em)
      #set text(size: 字号.小一, font: fonts.宋体, weight: "bold")
      #let t = (
        (if degree == "PhD" { "博 士 " } else { "硕 士 " }) + (if academic { "" } else { "专 业 " }) + "学 位 论 文"
      )
      #box(width: 42%, justify-text(t))
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
    columns: (3.33cm, 3.7cm, 0.15cm, 0.82cm, 1fr),
    rows: (1cm, 1cm),
    align: left,
    [], [#justify-text("研 究 生")], [], [：], info.author,
    [], [#justify-text("指 导 教 师")], [], [：], info.supervisor.join(),
  )
  grid(
    align: top,
    columns: 1,
    rows: (2cm, 1.24cm, 1.24cm),
    [],
    [南方科技大学],
    [#datetime-display-upper(info.defend-date)],
  )

  // 4.2 中文题名页

  // TODO

  // v(50pt)

  // text(font: fonts.楷体, size: 字号.三号, datetime-display(info.submit-date))


  // // 第二页
  // pagebreak(weak: true)

  // v(161pt)

  // block(width: 284pt, grid(
  //   columns: (defense-info-key-width, 1fr),
  //   column-gutter: defense-info-column-gutter,
  //   row-gutter: defense-info-row-gutter,
  //   defense-info-key("答辩委员会主席"),
  //   defense-info-value("chairman", info.chairman),
  //   defense-info-key("评阅人"),
  //   ..info.reviewer.map((s) => defense-info-value("reviewer", s)).intersperse(defense-info-key("　")),
  //   defense-info-key("论文答辩日期"),
  //   defense-info-value("defend-date", info.defend-date, no-stroke: true),
  // ))

  // v(216pt)

  // align(left, box(width: 7.3em, text(font: fonts.楷体, size: 字号.三号, weight: "bold", justify-text(with-tail: true, "研究生签名"))))

  // v(7pt)

  // align(left, box(width: 7.3em, text(font: fonts.楷体, size: 字号.三号, weight: "bold", justify-text(with-tail: true, "导师签名"))))

  // // 第三页英文封面页
  // pagebreak(weak: true)

  // set text(font: fonts.楷体, size: 字号.小四)
  // set par(leading: 1.3em)

  // v(45pt)

  // text(font: fonts.黑体, size: 字号.二号, weight: "bold", info.title-en.intersperse("\n").sum())

  // v(36pt)

  // text(size: 字号.四号)[by]

  // v(-6pt)

  // text(font: fonts.黑体, size: 字号.四号, weight: "bold", anonymous-text("author-en", info.author-en))

  // v(11pt)

  // text(size: 字号.四号)[Supervised by]

  // v(-6pt)

  // text(font: fonts.黑体, size: 字号.四号, anonymous-text("supervisor-en", info.supervisor-en))

  // if info.supervisor-ii-en != "" {
  //   v(-4pt)

  //   text(font: fonts.黑体, size: 字号.四号, anonymous-text("supervisor-ii-en", info.supervisor-ii-en))

  //   v(-9pt)
  // }

  // v(26pt)

  // [
  //   A dissertation submitted to  \
  //   the graduate school of #(if not anonymous { "Nanjing University" })  \
  //   in partial fulfilment of the requirements for the degree of  \
  // ]

  // v(6pt)

  // smallcaps(info.degree.at(1))

  // v(6pt)

  // [in]

  // v(6pt)

  // info.major-en

  // v(46pt)

  // if not anonymous {
  // }

  // v(28pt)

  // info.department-en

  // v(2pt)

  // if not anonymous {
  //   [Nanjing University]
  // }

  // v(28pt)

  // datetime-en-display(info.submit-date)
}
