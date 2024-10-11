#import "../utils/style.typ": 字号, 字体
#import "../utils/state-notations.typ": print-notations, notations
#import "outline-page.typ": outline-pagenum, outline-final

#let notation-page(
	twoside: false,
	title: "符号和缩略语说明",
	outlined: false,
	width: 90%,
	columns: (0.25fr, 1fr),
	row-gutter: 16pt,
	supplements: (),
) = {
  set page(..outline-pagenum())

	heading(
		level: 1,
		numbering: none,
		outlined: outlined,
		title
	)
	v(1em)
	// 符号表
	context align(center, block(width: width,
		align(start, grid(
			columns: columns,
			row-gutter: row-gutter,
			..(
					notations.final().pairs().
					filter(kv => kv.at(0) != "test").
					sorted().
					map(kv => print-notations(..kv.at(1))).
					filter(v => v != none)
				).flatten(),
			..supplements.flatten()
		))
	))
	outline-final("notation", twoside: twoside)
}