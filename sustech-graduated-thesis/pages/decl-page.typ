#import "../utils/style.typ": 字号, 字体
#import "../utils/page-break.typ": page-break

// 研究生声明页
#let decl-page(
	anonymous: false,
	twoside: false,
	fonts: (:),
) = {
	// 0. 如果需要匿名则短路返回
	if anonymous {
		return
	}

	// 1.  默认参数
	fonts = 字体 + fonts

	// 2.  正式渲染
	page-break(twoside: twoside)

	v(24pt)
	align(
		center,
		text(
			font: fonts.黑体,
			size: 字号.三号,
			"南方科技大学学位论文原创性声明和使用授权说明",
		),
	)
	v(18pt)

	v(24pt)
	align(
		center,
		text(
			font: fonts.黑体,
			size: 字号.四号,
			"南方科技大学学位论文原创性声明",
		),
	)
	v(6pt)

	block[
		#set text(font: fonts.宋体, size: 字号.小四)
    #set par(justify: true, first-line-indent: (amount: 2em, all: true), leading: 1.2em)

		~

		本人郑重声明：所提交的学位论文是本人在导师指导下独立进行研究工作所取得的成果。除了特别加以标注和致谢的内容外，论文中不包含他人已发表或撰写过的研究成果。对本人的研究做出重要贡献的个人和集体，均已在文中作了明确的说明。本声明的法律结果由本人承担。

		~
		
		作者签名：#h(10em)　　日　期：

		~
	]

	v(24pt)
	align(
		center,
		text(
			font: fonts.黑体,
			size: 字号.四号,
			"南方科技大学学位论文使用授权书",
		),
	)
	v(6pt)

	block[
		#set text(font: fonts.宋体, size: 字号.小四)
    #set par(justify: true, first-line-indent: (amount: 2em, all: true), leading: 1.2em)

		~

		本人完全了解南方科技大学有关收集、保留、使用学位论文的规定，即：
		1. 按学校规定提交学位论文的电子版本。
		2. 学校有权保留并向国家有关部门或机构送交学位论文的电子版，允许论文被查阅。
		3. 在以教学与科研服务为目的前提下，学校可以将学位论文的全部或部分内容存储在有关数据库提供检索，并可采用数字化、云存储或其他存储手段保存本学位论文。
		（1）在本论文提交当年，同意在校园网内提供查询及前十六页浏览服务。
		（2）在本论文提交□当年/□  年以后，同意向全社会公开论文全文的在线浏览和下载。
		4. 保密的学位论文在解密后适用本授权书。

		~
		
		作者签名：#h(10em)　　日　期：

		~

		指导教师签名：#h(10em)日　期：
	]
}