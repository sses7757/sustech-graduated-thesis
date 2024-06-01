#import "../utils/style.typ": 字号, 字体
#import "../utils/state-notations.typ": print-notations
#import "../utils/page-break.typ": page-break

#let notation-page(
	twoside: false,
	title: "符号和缩略语说明",
	outlined: false,
	width: 350pt,
	columns: (60pt, 1fr),
	row-gutter: 16pt,
	supplements: (),
	notations,
) = {
  set page(footer: context [
    #set align(center)
    #set text(字号.五号)
    #counter(page).display(
      "I of I",
      both: false,
    )
  ])

	heading(
		level: 1,
		numbering: none,
		outlined: outlined,
		title
	)

	context align(center, block(width: width,
		align(start, grid(
			columns: columns,
			row-gutter: row-gutter,
			..(
					notations.pairs().
					filter(kv => kv.at(0) != "test").
					map(kv => print-notations(..kv.at(1))).
					filter(v => v != none)
				).flatten(),
			..supplements.flatten()
		))
	))

	page-break(twoside: twoside)
}