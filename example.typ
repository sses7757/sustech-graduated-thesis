#import "sustech-master-thesis/lib.typ": documentclass, indent, notation, notations, fake-par

// 参考 modern-nju-thesis：
// 你首先应该安装 https://github.com/nju-lug/modern-nju-thesis/tree/main/fonts/FangZheng 里的所有字体，
// 如果是 Web App 上编辑，你应该手动上传这些字体文件，否则不能正常使用「楷体」和「仿宋」，导致显示错误。

#let (
	// 布局函数
	twoside, doc, mainmatter, mainmatter-end, appendix,
	// 页面函数
	fonts-display-page, cover, decl-page, abstract, abstract-en, bilingual-bibliography,
	outline-page, list-of-figures, list-of-tables, notation-page, acknowledgement,
) = documentclass(
	doctype: "midterm", // proposal, midterm, final
	// anonymous: true,  // 盲审模式
	twoside: true,  // 双面模式，会加入空白页，便于打印
	// fonts: (楷体: ("Times New Roman", "FZKai-Z03S")), 	// 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
	// math-font: "XITS Math", // 公式字体，应预先安装在系统中或放在根目录下
	// slant-glteq: true, // 公式 <= >= 样式，按照中文格式要求，所有大于等于、小于等于号均替换为对应倾斜等号变体
	// arounds: arounds_default, // 公式不加空格的符号，默认值为 mainmatter.arounds_default
	// math-breakable: false, // 多行公式可否分割到多页
	info: (
		title: ("基于Typst的", "南方科技大学学位论文"),
		title-en: "SUSTech Thesis Template for Typst",
		grade: "20XX",
		student-id: "1234567890",
		author: "张三",
		author-en: "Zhang San",
		department: "某学院",
		department-en: "XX Department",
		dept: "某系",
		dept-en: "XX Department",
		major: "某专业",
		major-en: "XX Major",
		field: "某方向",
		field-en: "XX Field",
		supervisor: ("李四", "教授"),
		supervisor-en: "Professor Li Si",
		// supervisor-ii: ("王五", "副教授"),
		// supervisor-ii-en: "Professor My Supervisor",
		submit-date: datetime.today(),
	),
	// 参考文献源
	bibliography: bibliography.with("example.bib"),
)

// 文稿设置
#show: doc

// 字体展示测试页
// #fonts-display-page()

// 封面页
#cover()

// 声明页
#decl-page()

// 正文
#show: mainmatter

// 中文摘要
#abstract(
	keywords: ("我", "就是", "测试用", "关键词")
)[
	中文摘要
]

// 英文摘要
#abstract-en(
	keywords: ("Dummy", "Keywords", "Here", "It Is")
)[
	English abstract
]

// 目录
#outline-page()

// 插图目录
#list-of-figures()

// 表格目录
#list-of-tables()

// 符号表
#context notation-page(notations.final(), supplements: (
		([$lambda$], "特征值"),
		([$pi$], "圆周率"),
	)
)


// 重设页码，开始正文

#counter(page).update(1)


= 导　论

自动断字测试：
#lorem(50)

== 列表

=== 无序列表

无序列表编号请自行使用`#set list(indent: 1em, marker: (...))`等方式修改符号和缩进。

#set list(indent: 1em, marker: ([•], [#text(size: 0.5em, baseline: 0.2em, "■")]))

- 无序列表项一
- 无序列表项二
	- 无序子列表项一
	- 无序子列表项二

=== 有序列表

有序列表编号请自行使用`#set enum(numbering: "(1 a)", indent: 0.35em)`等方式修改编号和缩进。

#set enum(numbering: "(1 a)", indent: 0.35em)

+ 有序列表项一#lorem(15)
+ 有序列表项二
	+ 有序子列表项一
	+ 有序子列表项二

== 术语

定义新术语，使用`#notation("key", name-en: "English Full Name", name-cn: "中文全称", abbr: "EFN")`，其中`abbr`可不指定以自动生成，`name-en`可以首字母不大写，如#notation("dft", name-en: "density functional theory", name-cn: "密度泛函理论")；字母中存在大写的，默认简写为其大写部分，如#notation("bana", name-en: "BA-NAnas", name-cn: "香蕉")。

引用已经定义的术语，使用`#notation("key", full: true|false|none)`，其中键值`key`的大小写不敏感，如#notation("DFT")、#notation("bana", full: none)和#notation("dft", full: true)。

文档中使用`notation`添加的所有术语均会自动出现在符号表中；同一个`key`，之后的定义会覆盖之前的定义。


== 图表

引用@tbl:timing-tlt，以及@fig:logo，具体参数设置参见Typst文档。引用图表时，表格和图片分别需要加上`tbl:`和`fig:`前缀才能正常显示编号。

#figure(
	table(
		columns: 4,
		stroke: none,
		table.hline(),
		[t], [1], [2], [3],
		table.hline(stroke: .5pt),
		[y], [0.3s], [0.4s], [0.8s],
		table.hline(),
	),
	caption: [三线表],
) <timing-tlt>

#figure(
	image("figs/LOGO.png", width: 50%),
	caption: [图片测试],
) <logo>


== 数学公式

可以像Markdown一样写行内公式$x + y$（\$与字符之间没有空格），以及带编号的行间公式（\$与字符之间存在空格或换行）：
$
phi.alt := (1 + sqrt(5)) / 2
$ <ratio>
默认字体为XITS Math，可按需修改`math-font`选项以改为所需字体，选项接收的参数为*字体名称*而非字体文件的名称，且字体应预先安装在系统中或放在根目录下。

引用数学公式需要加上`eqt:`前缀，则由@eqt:ratio，我们有：
$
 F_n &= P(n) \ 
	&= floor(1 / sqrt(5) phi.alt^n).
$
我们也可以通过`<->`标签来标识该行间公式不需要编号
$
f(bold(y)/t) <= integral_1^2 x^(-2) dif x,
$ <->
而后续数学公式仍然能正常编号：
$
F_n = floor(1 / sqrt(5) phi.alt^n).
$
使用 `<->` 标签配合内部标签实现单独标记：
$
 F_n &= P(n) \ 
	&= floor(1 / sqrt(5) phi.alt^n). #<final1>
$ <->
测试引用@eqt:final1。注意到默认情况下，多行公式不能分割到多页上，如需改变，修改`math-breakable`选项。

本模板加入了自动在行内公式两端添加空格的功能，如$sin(x)$，该功能会自动避免在符号两端添加空格。修改`arounds`选项以指定哪些符号两端不添加空格。


== 参考文献 <sec:bib>

可以像这样引用参考文献：图书#[@蒋有绪1998]和会议#[@中国力学学会1990]。

== 代码块

代码块支持语法高亮。引用时需要加上`lst:`，如@lst:code。

#figure(
	```py
	def add(x, y):
		return x + y
	```,
	caption:[代码块],
) <code>

== 注意事项

- 为了避免不必要的空格，中文内部（包括标点符号）不能换行。
  否则就像本行，在第一个句号后加入了额外的空格。
- 为了使得标题后首行文字可以缩进，本模板使用了`#fake-par`，会导致标题行和下一行可能不同页，如@sec:bib，建议使用手动换行“`\`”解决。
- 另外，对于行间公式和有序/无序列表之后马上需要另起一段的，需使用`#fake-par`另起一段，仅使用空行无法另起一段。
#fake-par
注意事项结束。


= 正文 <chap:2>

== 正文子标题

=== 正文子子标题

引用测试@chap:2。公式编号测试：
$
phi.alt := (1 + sqrt(5)) / 2
$ <ratio2>
测试引用@eqt:ratio2。



// 中英双语参考文献
// 默认使用 gb-7714-2015-numeric 样式
#bilingual-bibliography(full: true)

// 致谢
#acknowledgement[
	感谢modern-nju-thesis模板，感谢SUSTech LaTeX模板。
]


// 附录
#show: appendix

= 附录 A

== 附录子标题

=== 附录子子标题

附录内容，这里也可以加入图片，例如@fig:appendix-img。

#figure(
	image("figs/LOGO.png", width: 50%),
	caption: [图片测试],
) <appendix-img>

= 附录 B

== 附录子标题

=== 附录子子标题

公式编号测试：
$
phi.alt := (1 + sqrt(5)) / 2
$ <ratio3>
测试引用@eqt:ratio3。


// 正文结束标志，不可缺少
// 这里放在附录后面，使得页码能正确计数
#mainmatter-end()