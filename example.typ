#import "sustech-graduated-thesis/lib.typ": documentclass, no-indent, notation, 字体, pseudocode, pseudocode-list
#import "sustech-graduated-thesis/utils/math-utils.typ": sfrac, svec

// 参考 modern-nju-thesis：
// 你首先应该安装 https://github.com/nju-lug/modern-nju-thesis/tree/main/fonts/FangZheng 里的所有字体，
// 如果是 Web App 上编辑，你应该手动上传这些字体文件，否则不能正常使用「楷体」和「仿宋」，导致显示错误。

#let (
  // 布局函数
  twoside,
  doc,
  mainmatter,
  appendix,
  // 页面函数
  fonts-display-page,
  cover,
  decl-page,
  abstract,
  abstract-en,
  bilingual-bibliography,
  outline-page,
  list-of-figures,
  list-of-tables,
  notation-page,
  acknowledgement,
) = documentclass(
  doctype: "final", // proposal, midterm, final
  degree: "MEng", // 参考`degree-names.typ`
  academic: true, // 学术学位，若为false需要传入info.major-short
  // anonymous: true,  // 盲审模式
  twoside: true, // 双面模式，会加入空白页，便于打印
  // fonts: (楷体: ("Times New Roman", "FZKai-Z03S")), 	// 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  // math-font: "XITS Math", // 公式字体，应预先安装在系统中或放在根目录下
  // slant-glteq: true, // 公式 <= >= 样式，按照中文格式要求，所有大于等于、小于等于号均替换为对应倾斜等号变体
  // arounds: arounds_default, // 公式不加空格的符号，默认值为 mainmatter.arounds_default
  // math-breakable: false, // 多行公式可否分割到多页
  // sep-ref: true, // 是否自动将@ref与其跟随的中文字符分开处理，使用true时应避免含有中文的label或bib
  info: (
    title: "基于Typst的南方科技大学学位论文",
    title-en: "SUSTech Thesis Template for Typst",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "某系",
    department-en: "XX Department",
    major: "某专业",
    major-short: "材料与XX",
    major-en: "XX Major",
    major-en-short: "Materials and XX",
    field: "某方向",
    field-en: "XX Field",
    supervisor: ("李四", "教授"),
    supervisor-en: "Prof. Li Si",
    clc: "O643.12", // 国内图书分类号
    udc: "544.4", // 国际图书分类号
    school-code: "14325",
    secret-level: "公开",
    // supervisor-ii: ("王五", "副教授"),
    // supervisor-ii-en: "Prof. My Supervisor",
    submit-date: datetime.today(),
    defend-date: datetime.today(), // 答辩时间，一般为当年5月份
    bottom-date: datetime.today(), // 封面时间，一般为当年6月份
  ),
  // 参考文献源
  bibliography: bibliography.with("example.bib"),
)

// 文稿设置
#show: doc

// 字体展示测试页
// #fonts-display-page()

// 封面页
#cover(reviewers: (
    [刘XX], [教授], [南方科技大学],
    [陈XX], [副教授], [XXXX大学],
    [杨XX], [研究员], [中国XXXX科学院XXXXXXX研究所]
  ),
  committee: (
    [主席], [赵 XX], [教授], [南方科技大学],
    [委员], [刘 XX], [教授], [南方科技大学],
    [], [杨 XX], [研究员], [中国 XXXX 科学院],
    [], [黄 XX], [教授], [XXXXXX 研究所],
    [], [周 XX], [副教授], [XXXX 大学],
    [秘书], [吴 XX], [助理研究员], [南方科技大学]
  ),
)

// 声明页
#decl-page()

// 正文
#set list(indent: 1.1em, marker: ([•], [#text(size: 0.5em, baseline: 0.2em, "■")]))
#set enum(numbering: "（1 a）", indent: 0em)
#show: mainmatter

// 中文摘要，非最终报告会被隐藏
#abstract(keywords: ("我", "就是", "测试用", "关键词", "关键词", "关键词", "关键词", "关键词", "关键词"))[
  中文摘要
]

// 英文摘要，非最终报告会被隐藏
#abstract-en(
  keywords: (
    "Dummy",
    "Keywords",
    "Here",
    "It Is",
    "It Is",
    "It Is",
    "It Is",
    "It Is",
    "It Is",
    "It Is",
    "It Is",
    "Keywords",
    "Keywords",
    "Keywords",
    "Keywords",
    "Keywords",
  ),
)[
  English abstract
]

// 目录
#outline-page()

// 插图目录，非最终报告会被隐藏
#list-of-figures()

// 表格目录，非最终报告会被隐藏
#list-of-tables()

// 符号表
#notation-page(
  supplements: (
    ([$lambda$], "特征值"),
    ([$pi$], "圆周率"),
  ),
)


// 重设页码，开始正文
#counter(page).update(1)


= 导　论

自动断字测试：
#lorem(40)

== 列表

=== 无序列表

无序列表编号请自行使用`#set list(indent: 1em, marker: (...))`等方式修改符号和缩进。

- 无序列表项一
- 无序列表项二
  - 无序子列表项一
  - 无序子列表项二

=== 有序列表

有序列表编号请自行使用`#set enum(numbering: "（1 a）", indent: 0em)`等方式修改编号和缩进。

+ 有序列表项一#lorem(15)
+ 有序列表项二
  + 有序子列表项一
  + 有序子列表项二
#no-indent[如果在列表之后不希望下一段有缩进，请使用`no-indent`包裹，如本段所示。]

== 术语

定义新术语，使用`#notation("key", name-en: "English Full Name", name-cn: "中文全称", abbr: "EFN")`，其中`abbr`可不指定以自动生成，`name-en`可以首字母不大写，如#notation("dft", name-en: "density functional theory", name-cn: "密度泛函理论")；字母中存在大写的，默认简写为其大写部分，如#notation("bana", name-en: "BA-NAnas", name-cn: "香蕉")。

引用已经定义的术语，使用`#notation("key", full: true|false|none)`，其中键值`key`的大小写不敏感，如#notation("DFT")、#notation("bana", full: none)和#notation("dft", full: true)。

文档中使用`notation`添加的所有术语均会自动出现在符号表中；同一个`key`，之后的定义会覆盖之前的定义。

本模板还提供了快速定义和引用术语的方式，如全称“#notation("qft", "量子场论", "Quantum Field Theory")”（后两个顺序可互换），无键值“#notation("量子力学", "Quantum Mechanics")”。快速引用如@no:qft和@no:qft-full。


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
默认字体为XITS Math（可在`https://github.com/aliftype/xits/blob/master/XITSMath-Regular.otf`中下载），可按需修改`math-font`选项以改为所需字体，选项接收的参数为*字体名称*而非字体文件的名称，且字体应预先安装在系统中或放在根目录下。引用数学公式需要加上`eqt:`前缀，例如，则由@eqt:ratio，有：
$
  F_n &= P(n) \
  &= floor(1 / sqrt(5) phi.alt^n).
$
我们也可以通过`<->`标签来标识该行间公式不需要编号
$
  f(bold(y) / t) <= integral_1^2 x^(-2) dif x,
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

行内公式自动添加空格功能：
- 本模板加入了自动在行内公式两端添加空格的功能，如$sin(x)$，该功能会自动避免在符号两端添加空格。修改`arounds`选项以指定哪些符号两端不添加空格。
- 无序和有序列表以及图、表中的行内公式两端也会自动添加。
- 由于Typst本身没有提供类似LaTeX中的`\sfrac`和`\vec`类似的功能（`arrow()`的箭头默认大小对于某些字符过于巨大），因此，本模板在`utils/math-utils.typ`内提供了类似的函数——`sfrac`和`svec`。如$sfrac(A_L, B_d)$而非$A_L \/ B_d$，$svec(N)$而非$arrow(N)$。


== 参考文献 <sec:bib>

可以像这样引用参考文献：图书#[@蒋有绪1998]和会议#[@中国力学学会1990]。

注意事项：
- 若引用的key以中文开始，请按照上述写法编写引用。
- 若为全英文引用key，可以使用类似@Jiang1998的写法，无需包裹在content块内部，也不会自动添加不需要的空格，因为本模板的内置函数自动处理了这种情况。该处理同样适用于其他引用，如@eqt:final1引用。
- 若引用的key不以中文开始却含有中文，本模板在`sep-ref = true`的情况下目前*不能*正确处理，会出现错误，请自行修改引用键值或关闭`sep-ref`并全部使用上述写法（`#[@...]`）编写引用。
- Typst自动处理了连续引用的情况，会自动排序并添加连字符，如#[@蒋有绪1998@中国力学学会1990@Jiang1998]。

== 代码块

代码块支持语法高亮。引用时需要加上`lst:`，如@lst:code。

#figure(
  ```py
  def add(x, y):
  	return x + y
  ```,
  caption: [代码块],
) <code>

如果需要使用伪代码，本模板已经引入了`lovelace`库中的函数，如@fig:pseudo所示。

#figure(
  kind: "algorithm",

  pseudocode-list(booktabs: true, numbered-title: [样例算法])[
    + *输入*：$alpha$—样例输入1的解释；$beta$—样例输入2的解释
    + *输出*：$p$—样例输出1的解释；$q$—样例输出2的解释
    + *while* 未达到指定要求
      + $p arrow.l$循环计算$alpha$……
      + *if* $p > 1$ *then*
        + $q arrow.l$条件计算$beta$……
      + *else*
        + *break*
      + *end*
    + *end*
  ],
) <pseudo>

== 注意事项

- 如需设置全局格式，请在`#show: mainmatter`之前设置，或在设置之后再次应用`#show: mainmatter`，以免模板的某些全局设置失效。
- 按照学校要求，应使用有序列表编写毕业论文，本示例为了方便多数情况使用了无序列表。
- 其他未说明格式要求或存在冲突的，请按照学校规范执行。


== 表格自动填充

Typst提供了完整的文件读取和字符串处理处理功能，可以通过少量脚本代码自动生成表格内容，如@tbl:opt-res所示，该脚本读取了`test.csv`文件，将其奇数行视为不同方法在不同问题上的优化结果的平均值，偶数行视为其上一行的标准差，并统一加粗每一个问题上的最优结果。使用时可以自行参考下面的表格生成代码和`table`等Typst自带函数的语法进行修改和自定义。

#{
  import "@preview/oxifmt:0.2.1": strfmt
  let res-csv = csv("test.csv")
  let num-format(n, min-val: 0, format: "3E2") = {
    if format == none {
      if n == min-val [*#str(n)*] else [#str(n)]
    } else {
      let format-main = format.position("E") + 1
      let fmt = strfmt("{:." + format.slice(0, format-main) + "}", n)
      fmt = fmt.replace("E", "E+").replace("E+-", "E-")
      let p = fmt.position(regex("E[+-][0-9]+")) + 2
      let exp-n = strfmt("{:0" + format.slice(format-main) + "}", int(fmt.slice(p)))
      fmt = fmt.slice(0, p) + exp-n
      fmt = if fmt.starts-with("-") { fmt } else { "-" + fmt }
      fmt = fmt.replace("-", "−")
      if n == min-val [*#fmt*] else [#fmt]
    }
  }
  let parse-row(csv-str, row-idx) = {
    let row = (table.cell(rowspan: 2)[F#(row-idx + 1)], [Mean])
    let means = csv-str.at(row-idx * 2).map(x => eval(x))
    let stds = csv-str.at(row-idx * 2 + 1).map(x => eval(x))
    let min-mean = calc.min(..means)
    let min-std = calc.min(..stds)
    row += means.map(num-format.with(min-val: min-mean))
    row += ([Std],) + stds.map(num-format.with(min-val: min-std))
    row
  }
  let _next-page-state = state("next-page-state", false)
  show figure: set block(breakable: true)
  [#figure(
      table(
        columns: (0.3fr, 0.7fr) + (1fr,) * 6,
        align: center + horizon,
        stroke: 0pt,
        table.hline(stroke: 1pt),
        table.header(
          table.cell(colspan: 2)[*函数*],
          ..range(1, 7).map(x => [方法#x]),
        ),
        table.hline(stroke: 0.5pt),
        ..range(0, int(res-csv.len() / 2)).map(x => parse-row(res-csv, x)).flatten(),
        table.hline(stroke: 1pt),
        table.footer(
          table.cell(
            colspan: 8,
            align: right + bottom,
            context if _next-page-state.get() [] else [续下页#_next-page-state.update(_ => true)],
          ),
        )
      ),
      caption: [表格内容自动生成测试],
    ) <opt-res>
  ]
}


= 正文 <chap:2>

== 正文子标题

=== 正文子子标题

引用测试@chap:2。公式编号测试：
$
  phi.alt := (1 + sqrt(5)) / 2
$ <ratio2>
测试引用@eqt:ratio2。


#heading(level: 1, numbering: none, "结　论")

测试结论。


// 中英双语参考文献
// 默认使用 gb-7714-2015-numeric 样式
#bilingual-bibliography(full: true)

// 致谢，非最终报告会被隐藏
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
  "test" + q
$ <appendix>
测试引用@eqt:appendix。
