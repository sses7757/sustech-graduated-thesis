#import "@preview/outrageous:0.1.0"
#import "../utils/page-break.typ": page-break
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/style.typ": 字号, 字体

// 目录生成
#let outline-page(
	// documentclass 传入参数
	twoside: false,
	fonts: (:),
	// 其他参数
	depth: 3,
	title: "目　录",
	outlined: false,
	title-vspace: 0pt,
	title-text-args: auto,
	// 引用页数的字体，这里用于显示 Times New Roman
	reference-font: auto,
	reference-size: 字号.小四,
	// 字体与字号
	font: auto,
	size: (字号.小四, ),
	// 垂直间距
	vspace: (25pt, 14pt),
	indent: (0pt, 1em, 1em),
	// 全都显示点号
	fill: (auto,),
	..args,
) = {
	// 1.  默认参数
	fonts = 字体 + fonts
	if (title-text-args == auto) {
		title-text-args = (font: fonts.黑体, size: 字号.三号)
	}
	// 引用页数的字体，这里用于显示 Times New Roman
	if (reference-font == auto) {
		reference-font = fonts.宋体
	}
	// 字体与字号
	if (font == auto) {
		font = (fonts.黑体, fonts.宋体)
	}

	// 2.  正式渲染
	page-break(twoside: twoside)
	counter(page).update(1)
	set page(footer: context [
		#set align(center)
		#set text(字号.五号)
		#counter(page).display(
			"I of I",
			both: false,
		)
	])

	// 默认显示的字体
	set text(font: reference-font, size: reference-size)
	heading(level: 1, numbering: none, outlined: outlined, title)

	v(title-vspace)

	show outline.entry: outrageous.show-entry.with(
		// 保留 Typst 基础样式
		..outrageous.presets.typst,
		body-transform: (level, it) => {
			// 设置字体和字号
			set text(
				font: font.at(calc.min(level, font.len()) - 1),
				size: size.at(calc.min(level, size.len()) - 1),
			)
			// 计算缩进
			let indent-list = indent + range(level - indent.len()).map((it) => indent.last())
			let indent-length = indent-list.slice(0, count: level).sum()
			h(indent-length) + it
		},
		vspace: vspace,
		fill: fill,
		..args,
	)

	// 显示目录
	outline(title: none, depth: depth)

}