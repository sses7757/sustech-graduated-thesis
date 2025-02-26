#import "../utils/style.typ": 字号, 字体
#import "../utils/page-break.typ": page-break
#import "../utils/invisible-heading.typ": invisible-heading

// 研究生中文摘要页
#let abstract-en(
	// documentclass 传入的参数
	twoside: false,
	fonts: (:),
	// 其他参数
	keywords: (),
	outline-title: "Abstract",
	outlined: true,
	abstract-title-weight: "regular",
	body,
) = {
	fonts = 字体 + fonts

	page-break(twoside: twoside)

	// 标记一个不可见的标题用于目录生成
	invisible-heading(level: 1, outlined: outlined, outline-title)

	v(24pt)
	align(center)[
		#set par(spacing: 0pt)
		#text(font: fonts.黑体, size: 字号.三号, weight: abstract-title-weight, "Abstract")
	]
	v(18pt)
	[
		#set text(font: fonts.宋体, size: 字号.小四)
		#set par(first-line-indent: (amount: 2em, all: true))
		#body

		~

		#set par(first-line-indent: (amount: 0pt, all: true), justify: false, hanging-indent: 4em)
		*Keywords:* #(("",) + keywords.intersperse("; ")).sum()
	]
}