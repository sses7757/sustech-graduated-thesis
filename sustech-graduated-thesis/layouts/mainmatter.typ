#import "@preview/i-figured:0.2.4": reset-counters
#import "../utils/multi-line-equate.typ": show-figure, equate, equate-ref
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/unpairs.typ": unpairs
#import "../utils/eq-wrap.typ": eq-wrap, arounds_default


#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  leading: 1em,
  spacing: 1em,
  justify: true,
  first-line-indent: (amount: 2em, all: true),
  numbering: custom-numbering.with(first-level: "第1章　", depth: 4, "1.1　"),
  // 正文字体与字号参数
  text-args: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (字号.三号, 字号.四号, 13pt, 字号.小四),
  heading-weight: ("regular",),
  heading-above: (24pt + 0.5em, 24pt, 22pt),
  heading-below: (18pt + 0.75em, 6pt + 1em, 6pt + 1em),
  heading-pagebreak: (true, false),
  heading-align: (center, auto),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: true,
  skip-on-first-level: false,
  stroke-width: 0.5pt,
  reset-footnote: true,
  // caption 的 separator
  separator: "　",
  // caption 样式
  caption-size: 11pt,
  // figure 计数
  show-figure: show-figure,
  // 公式计数
  show-equation: equate,
  slant-glteq: true,
  math-font: "XITS Math",
  arounds: arounds_default,
  math-breakable: false,
  sep-ref: true,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  set page(numbering: "1")

  // 1.  默认参数
  fonts = 字体 + fonts
  if (text-args == auto) {
    text-args = (font: fonts.宋体, size: 字号.小四)
  }
  // 1.1 字体与字号
  if (heading-font == auto) {
    heading-font = (fonts.黑体,)
  }
  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: spacing,
    linebreaks: "optimized",
  )
  show raw: set text(font: fonts.等宽, size: 1.175em, baseline: -0.05em)
  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // 3.3 设置 figure 的编号
  show heading: reset-counters.with(extra-kinds: ("algorithm",))
  show figure: show-figure
  // 3.4 设置 equation 的编号和假段落首行缩进
  show math.equation: set text(font: if type(math-font) == array { math-font } else { (math-font,) } + fonts.宋体)
  show math.equation.where(block: true): show-equation.with(breakable: math-breakable)
  show math.equation.where(block: true): set par(leading: 0.5em, spacing: 0em)
  set math.equation(supplement: "公式")
  set math.equation(numbering: "(1-1a)")
  show ref: equate-ref.with(sep-ref: sep-ref)
  show math.gt.eq: math.class("binary", if slant-glteq { sym.gt.eq.slant } else { sym.gt.eq })
  show math.lt.eq: math.class("binary", if slant-glteq { sym.lt.eq.slant } else { sym.lt.eq })
  // 3.6 表格表头置顶 + 不用冒号用空格分割 + 样式
  set figure(gap: 0.75em)
  show figure.where(kind: image): set figure(supplement: "图")
  show figure.where(kind: image): set block(above: 1em, below: 1.5em)
  show figure.where(kind: table): set figure(supplement: "表")
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set block(above: 1.5em, below: 1em)
  show figure.where(kind: raw): set figure(supplement: "代码")
  show figure.where(kind: raw): set block(above: 1em, below: 1.5em)
  show figure.where(kind: "algorithm"): set figure(supplement: "算法")
  show figure.where(kind: "algorithm"): set block(above: 1em, below: 1.5em)
  set figure.caption(separator: separator)
  show figure.caption: set text(font: fonts.宋体, size: caption-size)
  show table: set text(size: caption-size)
  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  show heading.where(level: 4): set heading(bookmarked: false)
  show heading.where(level: 5): set heading(bookmarked: false)
  // 4.2 设置字体字号
  // 4.3 标题居中与自动换页
  show heading: it => {
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (pair.at(0), array-at(pair.at(1), it.level)))),
    )
    set block(
      above: if it.level == 1 { 0pt } else { array-at(heading-above, it.level) },
      below: array-at(heading-below, it.level),
    )
    if (array-at(heading-pagebreak, it.level)) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if ("label" not in it.fields() or str(it.label) != "no-auto-pagebreak") {
        pagebreak(weak: true)
        v(array-at(heading-above, it.level))
      }
    }
    if (array-at(heading-align, it.level) != auto) {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }
  // 4.4 标题引用
  show ref: it => {
    if it.element == none { return it }
    if it.element.func() != heading { return it }
    let e = it.element
    let num-str = (e.numbering)(..counter(heading).at(e.location()))
    num-str = num-str.trim()
    if e.level == 1 {
      link(e.location(), num-str)
    } else {
      link(e.location(), [第#num-str 节])
    }
  }

  // 5.  处理页眉页脚
  set page(
    ..(
      if display-header {
        (
          header: context {
            // 重置 footnote 计数器
            if reset-footnote {
              counter(footnote).update(0)
            }
            let loc = here()
            // 5.1 获取当前页面的一级标题
            let cur-heading = current-heading(level: 1)
            // 5.2 如果当前页面没有一级标题，则渲染页眉
            if not skip-on-first-level or cur-heading == none {
              if header-render == auto {
                let heading = heading-display(active-heading(level: 1, prev: false, loc))
                set text(font: fonts.宋体, size: 字号.五号)
                stack(
                  align(center, heading),
                  v(0.25em),
                  line(length: 100%, stroke: stroke-width + black),
                )
              } else {
                header-render(loc)
              }
              v(header-vspace)
            }
          },
        )
      } else {
        (
          header: {
            // 重置 footnote 计数器
            if reset-footnote {
              counter(footnote).update(0)
            }
          },
        )
      }
    ),
    footer: context [
      #set align(center)
      #set text(字号.五号)
      #counter(page).display(both: false)
    ],
  )

  show: eq-wrap.with(arounds: arounds)

  counter(page).update(1)
  it
}
