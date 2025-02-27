// #import "@preview/outrageous:0.1.0"
#import "../utils/page-break.typ": page-break
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/style.typ": 字号, 字体

#let outline-pagenum() = (footer:
	context [
		#set align(center)
		#set text(字号.五号)
		#counter(page).display(
			"I of I",
			both: false,
		)
	]
)
#let _outline-end = state("outline-end", "outline")
#let outline-final(name, twoside: true) = {
	_outline-end.update(_ => name)
	context if _outline-end.final() == name {
		page-break(twoside: twoside)
	}
}

// 目录生成
#let outline-page(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  depth: 3,
  title: "目　录",
  outlined: false,
  title-vspace: 18pt,
  // 间距
  above: 14pt,
  below: 14pt,
  indent: auto,
  // 全都显示点号
  fill: repeat([.], gap: 0em),
  gap: .3em,
  ..args,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  if (indent == auto) {
    indent = (0pt, 字号.小四, 字号.小四 * 2)
  }

  // 2.  正式渲染
  set page(..outline-pagenum())
  page-break(twoside: twoside)
  counter(page).update(1)

  heading(level: 1, numbering: none, outlined: outlined, title)

  // 目录样式
  set outline(indent: level => if level > 3 {0pt} else {indent.at(level)})
  show outline.entry: set block(above: above, below: below)
  set outline.entry(fill: fill)
  show outline.entry.where(level: 1): it => block(
    link(
      it.element.location(),
      [
        #show regex("Abstract"): set text(weight: "bold")
        #text(font: (fonts.宋体.at(0), ..fonts.黑体))[
          #(if it.prefix() != none {it.prefix()} else {[]})
          #it.element.body
        ]
      #box(width: 1fr, inset: (x: .25em), fill)
      #let c = counter(page).at(it.element.location())
      #let page = numbering("I", ..c)
      #if it.element.numbering == none and c.at(0) < 7 { page } else { it.page() }
      ]
    )
  )
  // 显示目录
  outline(title: none, depth: depth)
}
