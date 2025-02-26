#import "../utils/style.typ": 字号, 字体

// 前言，重置页面计数器
#let preface(
	// documentclass 传入的参数
	twoside: false,
	fonts: (:),
	// 正文字体与字号参数
	text-args: auto,
	// 标题字体与字号
	heading-font: auto,
	// 其他参数
	spec: (front: "I", inner: "1", back: "I"),
	..args,
	it,
) = {
	// 分页
	if (twoside) {
		pagebreak() + " "
	}
	counter(page).update(0)
	set page(numbering: "I")

	// 默认参数
	fonts = 字体 + fonts
	if (text-args == auto) {
		text-args = (font: fonts.宋体, size: 字号.小四)
	}

	// 设置文本和段落样式
	set text(..text-args)

	// 显示页眉
	set page(
    header: context {
			let loc = here()
			// 获取当前页面的一级标题
			let cur-heading = current-heading(level: 1)
			// 如果有一级标题，则渲染页眉
			if cur-heading != none {
				let heading = heading-display(active-heading(level: 1, prev: false, loc))
				set text(font: fonts.宋体, size: 字号.五号)
				stack(
					align(center, heading),
					v(0.25em),
					line(length: 100%, stroke: 0.5pt + black)
				)
			}
		}
	)
}