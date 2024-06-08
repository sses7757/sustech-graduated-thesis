#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/justify-text.typ": justify-text
#import "../utils/style.typ": 字号, 字体
#import "../utils/degree-names.typ": degree-types

// 硕士研究生封面
#let nonfinal-cover(
	// documentclass 传入的参数
	doctype: "midterm",
	anonymous: false,
	twoside: false,
	fonts: (:),
	info: (:),
	// 其他参数
	stoke-width: 0.5pt,
	min-title-lines: 1,
	info-inset: (x: 0pt, bottom: 0.5pt),
	info-key-width: 96pt,
	info-column-gutter: 4pt,
	info-row-gutter: 14pt,
	datetime-display: datetime-display,
	datetime-en-display: datetime-en-display,
) = {
	// 1.  默认伪粗体
	show text.where(weight: "bold").or(strong): it => {
  	show regex("\p{script=Han}"): set text(stroke: 0.02857em)
  	it
	}

	// 2.  对参数进行处理
	// 2.1 如果是字符串，则使用换行符将标题分隔为列表
	if type(info.title) == str {
		info.title = info.title.split("\n")
	}
	if type(info.title-en) == str {
		info.title-en = info.title-en.split("\n")
	}
	// 2.2 根据 min-title-lines 填充标题
	info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
	// 2.3 处理日期
	assert(type(info.submit-date) == datetime, message: "submit-date must be datetime.")
	if type(info.defend-date) == datetime {
		info.defend-date = datetime-display(info.defend-date)
	}
	if type(info.confer-date) == datetime {
		info.confer-date = datetime-display(info.confer-date)
	}
	if type(info.bottom-date) == datetime {
		info.bottom-date = datetime-display(info.bottom-date)
	}

	// 3.  内置辅助函数
	let info-key(body, info-inset: info-inset) = {
		set text(
			font: fonts.宋体,
			size: 字号.三号,
			weight: "bold",
		)
		rect(
			width: 100%,
			inset: info-inset,
			stroke: none,
			justify-text(with-tail: false, body)
		)
	}

	let info-value(body, info-inset: info-inset, no-stroke: false) = {
		set align(center)
		rect(
			width: 100%,
			inset: info-inset,
			stroke: if no-stroke { none } else { (bottom: stoke-width + black) },
			text(
				font: fonts.宋体,
				size: 字号.三号,
				bottom-edge: "descender",
				weight: "bold",
				if type(body) == datetime [#body.display("[year]年[month]月[day]日")] else {body},
			),
		)
	}
	

	// 4.  正式渲染
	pagebreak(weak: true, to: if twoside { "odd" })

	// 居中对齐
	set align(center)

	// 开头标识
	// 将中文之间的空格间隙从 0.25 em 调整到 0.5 em
	v(字号.小一 * 2)
	text(size: 字号.小一, font: fonts.楷体, spacing: 100%, weight: "bold",
		"南 方 科 技 大 学"
	)
	v(字号.小一)
	text(size: 字号.小一, font: fonts.宋体, spacing: 100%, weight: "bold",
		if info.degree == "PhD"	{
			if doctype == "midterm" { "博 士 研 究 生 中 期 考 核 报 告" } else { "博 士 研 究 生 开 题 报 告" }
		} else {
			if doctype == "midterm" { "硕 士 研 究 生 中 期 考 核 报 告" } else { "硕 士 研 究 生 开 题 报 告" }
		},
	)
	v(字号.小一)
	// 题目
	text(size: 字号.小二, font: fonts.宋体, spacing: 100%, weight: "bold")[
		题目：#info.title.join()
	]
	
	// 中间标识
	v(字号.小一 * 2)

	block(width: 294pt, grid(
		columns: (info-key-width, 1fr),
		column-gutter: info-column-gutter,
		row-gutter: info-row-gutter,

		info-key("院 （系）"),
		info-value(info.dept),

		info-key("学 科"),
		info-value(info.major),
		
		info-key("导 师"),
		info-value(info.supervisor.intersperse(" ").sum()),
		..(if info.supervisor-ii != () {(
			info-key("　"),
			info-value(info.supervisor-ii.intersperse(" ").sum()),
		)} else { () }),

		info-key("研 究 生"),
		info-value(info.author),

		info-key("学 号"),
		info-value(info.student-id),

		info-key(if doctype == "midterm" {"中 期 考 核 日 期"} else {"开 题 报 告 日 期"}),
		info-value(info.submit-date),
	))

	v(字号.二号 * 6)

	text(size: 字号.三号, font:fonts.宋体, weight: "bold")[研究生院制]

}