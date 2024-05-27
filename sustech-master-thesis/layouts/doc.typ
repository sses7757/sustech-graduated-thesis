#import "../utils/style.typ": 字号, 字体

// 文稿设置，可以进行一些像页面边距这类的全局设置
#let doc(
	// documentclass 传入参数
	info: (:),
	fonts: (:),
	// 其他参数
	fallback: false,  // 字体缺失时使用 fallback，不显示豆腐块
	lang: "zh",
	margin: (x: 3cm, y: 3cm),
	it,
) = {
	// 1.  默认参数
	info = (
		title: ("基于Typst的", "南方科技大学学位论文"),
		author: "张三",
	) + info
	fonts = 字体 + fonts

	// 2.  对参数进行处理
	// 2.1 如果是字符串，则使用换行符将标题分隔为列表
	if type(info.title) == str {
		info.title = info.title.split("\n")
	}

	// 3.  基本的样式设置
	set text(fallback: fallback, hyphenate: auto)
	set par(justify: true)
	set page(margin: margin)
	show math.equation: set text(font: info.math-font)

	// 4.  PDF 元信息
	set document(
		title: (("",)+ info.title).sum(),
		author: info.author,
	)

	it
}