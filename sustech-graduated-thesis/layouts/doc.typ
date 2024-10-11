// 文稿设置，可以进行一些像页面边距这类的全局设置
#let doc(
	// documentclass 传入参数
	info: (:),
	// 其他参数
	fallback: true,  // 字体缺失时使用 fallback，不显示豆腐块
	lang: "zh",
	margin: (x: 3cm, y: 3.1cm),
	it,
) = {
	// 1.  对参数进行处理
	// 1.1 如果是字符串，则使用换行符将标题分隔为列表
	if type(info.title) == str {
		info.title = info.title.split("\n")
	}

	// 2.  基本的样式设置
	set text(fallback: fallback, hyphenate: auto)
	set par(justify: true)
	set page(margin: margin, header-ascent: 20%, footer-descent: 20%)

	// 3.  PDF 元信息
	set document(
		title: (("",) + info.title).sum(),
		author: info.author,
	)

	it
}