// NOTICE about license
// The majority of this file is originated from "EpicEricEE/typst-plugins/equate" with MIT license, with my modification to fit current demands.
// The `show-figure` function is originated from "RubixDev/typst-i-figured" with MIT license, with my modification to work with the rest of the functions.


// Element function for alignment points.
#let align-point = $&$.body.func()

// Element function for a counter update.
#let counter-update = counter(math.equation).update(1).func()

// Sub-numbering state.
#let state = state("equate/sub-numbering", false)

// Extract lines and trim spaces.
#let to-lines(equation) = {
	let lines = if equation.body.has("children") {
		equation.body.children.split(linebreak())
	} else {
		((equation.body,),)
	}

	// Trim spaces at begin and end of line.
	let lines = lines.filter(line => line != ()).map(line => {
		if line.first() == [ ] and line.last() == [ ] {
			line.slice(1, -1)
		} else if line.first() == [ ] {
			line.slice(1)
		} else if line.last() == [ ] {
			line.slice(0, -1)
		} else {
			line
		}
	})

	lines
}

// Layout a single equation line with the given number.
#let layout-line(
	number: none,
	number-align: none,
	number-width: auto,
	line
) = context {
	// Short circuit if no number has to be added.
	if number == none {
		return math.equation(block: true, numbering: _ => none, line.join())
	}

	// Short circuit if number is a counter update.
	if type(number) == content and number.func() == counter-update {
		return {
			number
			math.equation(block: true, numbering: _ => none, line.join())
		}
	}

	// Start of equation block.
	let x-start = here().position().x

	// Resolve number width.
	let number-width = if number-width == auto {
		measure(number).width
	} else {
		number-width
	}

	let equation-align = align.alignment.x

	layout(bounds => {
		// Add numbers to the equation body, so that they are aligned
		// at their respective baselines. They are wrapped in a zero-width box
		// to not mess with the center alignment.
		let body = line.join() + box(width: 0pt, context move(
			dx: x-start - here().position().x + if number-align.x == right { bounds.width },
			align(number-align, box(width: number-width, number))
		))

		// Make numbering take up space.
		let pad-key = if equation-align == center { "x" }
									else if number-align == left { "left" }
									else { "right" }

		let pad-arg = ((pad-key): number-width)
		pad(..pad-arg, math.equation(numbering: _ => none, block: true, body))
	})
}

// Replace "fake labels" with a hidden figure that is labelled
// accordingly. 
#let replace-labels(
	lines,
	has-main-number,
	numbering,
	supplement,
	prefix,
) = {
	// Main equation number.
	let main-number = counter(math.equation).get()

	// Indices of numbered lines in this equation.
	let numbered = if has-main-number {
		range(lines.len())
	} else {
		lines.enumerate()
			.filter(((i, line)) => {
				if line.len() == 0 { return false }
				if line.last().func() != raw { return false }
				if line.last().lang != "typc" { return false }
				if line.last().text.match(regex("^<.+>$")) == none { return false }
				return true
			})
			.map(((i, _)) => i)
	}

	lines.enumerate()
		.map(((i, line)) => {
			if line.len() == 0 { return line }

			let last = line.last()
			if last.func() != raw { return line }
			if last.lang != "typc" { return line }
			if last.text.match(regex("^<.+>$")) == none { return line }

			// Remove trailing spacing (before label).
			if line.at(-2, default: none) == [ ] { line.remove(-2) }

			// Append sub-numbering only if there are multiple numbered lines.
			let nums = main-number + if numbered.len() > 1 {
				(numbered.position(n => n == i) + 1,)
			}

			// We use a figure with kind "equation" to make the sub-equation
			// referenceable with the correct supplement. The numbering is stored
			// in the figure body as metadata, as a counter would only show a
			// single number.
			line.at(-1) = [#figure(
				metadata(nums),
				kind: math.equation,
				numbering: numbering,
				supplement: supplement
			)#label(prefix + last.text.slice(1, -1))]

			return line
		})
}

// Splitting an equation into multiple lines breaks the inbuilt alignment
// with alignment points, so it is emulated here by adding spacers manually.
#let realign(lines) = {
	// Utility shorthand for unnumbered block equation.
	let equation = math.equation.with(block: true, numbering: none)

	// Short-circuit if not alignment points.
	if lines.all(line => align-point() not in line) {
		return lines
	}

	// Store widths of each part between alignment points.
	let part-widths = lines.map(line => line
			.split(align-point())
			.map(part => measure(equation(part.join())).width))

	// Get maximum width of each part.
	let part-widths = for i in range(calc.max(..part-widths.map(points => points.len()))) {
		(calc.max(..part-widths.map(line => line.at(i, default: 0pt))), )
	}

	// Add spacers for each part, so that the part widths are the same for all lines.
	let lines = lines.map(line => {
		let parts = line.split(align-point())

		let spaced(i, spacing) = {
			let spacing = if spacing > 0pt { box(width: spacing) }
			if calc.even(i) {
				// Right align.
				spacing + parts.at(i).join()
			} else {
				// Left align.
				parts.at(i).join() + spacing
			}
		}

		parts.enumerate()
			.map(((i, part)) => {
				// Add spacer to make part the correct width.
				let width = part-widths.at(i) - measure(equation(part.join())).width
				let elem = equation(spaced(i, width))

				// Adjust for math class spacing between the spacer and the actual equation.
				equation(spaced(i, width + part-widths.at(i) - measure(elem).width))
			})
			.intersperse(align-point())
	})

	// Ensure correct spacing with all previous parts combined.
	let max-slice-widths = array.zip(..lines.map(line => range(part-widths.len()).map(i => {
		let parts = line.split(align-point()).map(array.join)
		if i >= parts.len() {
			0pt
		} else {
			let slice = parts.slice(0, i + 1).join()
			measure(equation(slice)).width
		}
	}))).map(widths => calc.max(..widths))

	lines = lines.map(line => {
		let parts = line.split(align-point()).map(array.join)
		for i in range(max-slice-widths.len()) {
			if i >= parts.len() {
				break
			}
			let slice = parts.slice(0, i + 1).join()
			let slice-width = measure(equation(slice)).width
			if slice-width < max-slice-widths.at(i) {
				parts.at(i) = box(width: max-slice-widths.at(i) - slice-width) + parts.at(i)
			}
		}
		parts
	})

	// Append remaining spacers at the end for lines that have less align points.
	let line-widths = lines.map(line => measure(equation(line.join())).width)
	let max-line-width = calc.max(..line-widths)
	lines = lines.zip(line-widths).map(((line, line-width)) => {
		if line-width < max-line-width {
			line.push(box(width: max-line-width - line-width))
		}
		line
	})

	lines
}


#let _prefix = "i-figured-"
#let _typst-numbering = numbering
#let _prepare-dict(it, level, zero-fill, leading-zero, numbering) = {
	let numbers = counter(heading).at(it.location())
	// if zero-fill is true add trailing zeros until the level is reached
	while zero-fill and numbers.len() < level { numbers.push(0) }
	// only take the first `level` numbers
	if numbers.len() > level { numbers = numbers.slice(0, level) }
	// strip a leading zero if requested
	if not leading-zero and numbers.at(0, default: none) == 0 {
		numbers = numbers.slice(1)
	}

	let dic = it.fields()
	let _ = if "body" in dic { dic.remove("body") }
	let _ = if "label" in dic { dic.remove("label") }
	let _ = if "counter" in dic { dic.remove("counter") }
	dic + (numbering: n => _typst-numbering(numbering, ..numbers, n))
}


#let show-figure(
	it,
	level: 1,
	zero-fill: true,
	leading-zero: true,
	numbering: "1-1",
	extra-prefixes: (:),
	fallback-prefix: "fig:",
	line-width: 21cm - 6cm,
) = {
	if (type(it.kind) == str and it.kind.starts-with(_prefix)) or it.kind == math.equation {
		return it
	}
	let f = figure(
		it.body,
		.._prepare-dict(it, level, zero-fill, leading-zero, numbering),
		kind: _prefix + repr(it.kind),
	)
	let res = if it.has("label") {
		let prefixes = (table: "tbl:", raw: "lst:") + extra-prefixes
		let new-label = label(prefixes.at(
				if type(it.kind) == str { it.kind } else { repr(it.kind) },
				default: fallback-prefix,
		) + str(it.label))
		[#f #new-label]
	} else {
		f
	}
	// move figure spacing and caption algin adjustment here to prevent unwanted spacing in multi-line equations
	if measure(it.caption).width > line-width {
		show figure.caption: set align(start + top)
		show figure.caption: set par(leading: 1em)
		res
	} else {
		res
	}
}


#let _prepare-equ-dict(it, num: none, supp: none) = {
	let dic = it.fields()
	let _ = if "body" in dic { dic.remove("body") }
	let _ = if "label" in dic { dic.remove("label") }
	let _ = if "counter" in dic { dic.remove("counter") }
	dic.insert("numbering", num)
	dic.insert("supplement", supp)
	return dic
}
// Applies show rules to the given body, so that block equations can span over
// page boundaries while retaining alignment. The equation number is stepped
// and displayed at every line, optionally with sub-numbering.
//
// ### Parameters:
// - breakable: wheteher the multi-line equations can be break to different pages
// - sub-numbering: whether to use the last number in the `math.equation.numbering` as the sub number
// - zero-fill: whether to fill 0s for the first (few) numbers when not present
// - leading-zero: wheter to set the first heading number to 0 if it is not numbered
// - unnumbered-label: the label to indicate that the equation shall not be numbered as whole
// - debug: show debug boxes
// - prefix: the label prefix to add before each label
//
// ### Example: 
// ```
// #set heading(numbering: "1.1")
// #show heading: it => {
// 	counter(math.equation).update(0)
// 	it
// }
// #show math.equation: equate
// #show ref: equate-ref
// #set math.equation(numbering: "(1.1.a)")
// ```
#let equate(
	breakable: false,
	sub-numbering: true,
	zero-fill: true,
	leading-zero: true,
	level: 1,
	unnumbered-label: "-",
	debug: false,
	prefix: "eqt:",
	it
) = {
	// Allow a way to make default equations.
	if (not it.block or it.has("label") and str(it.label).starts-with(prefix)) {
		return it
	}
	if ((not it.has("numbering") or it.numbering == none or numbering(it.numbering, 1) == none) and
			(not it.has("supplement") or it.supplement == none or it.supplement == [])) {
		let c = counter(math.equation).update(n => n - 1)
		return [#it#c]
	} else if (it.has("numbering") and it.numbering == none) {
		return it
	}
	// if (it.has("label") and str(it.label) == unnumbered-label) {
	// 	return math.equation(it.body, .._prepare-dict(it, num: it.numbering, supp: it.supplement))
	// }

	// Check numbering
	let has-main-label = it.has("label") and str(it.label) != unnumbered-label

	// Make spacers visible in debug mode.
	show box.where(body: none): set box(
		height: 0.5em,
		stroke: 0.4pt,
		fill: yellow
	) if debug

	// Main equation number.
	let main-number = counter(heading).at(it.location())
	// if zero-fill is true add trailing zeros until the level is reached
	while zero-fill and main-number.len() < level { main-number.push(0) }
	// only take the first `level` numbers
	if main-number.len() > level { main-number = main-number.slice(0, level) }
	// strip a leading zero if requested
	if not leading-zero and main-number.at(0, default: none) == 0 {
		main-number = main-number.slice(1)
	}
	main-number = main-number + (counter(math.equation).get().first(),)

	// Resolve text direction.
	let text-dir = if text.dir == auto {
		if text.lang in (
			"ar", "dv", "fa", "he", "ks", "pa",
			"ps", "sd", "ug", "ur", "yi",
		) { rtl } else { ltr }
	} else {
		text.dir
	}

	// Resolve number position in x-direction.
	let number-align = if it.number-align.x in (left, right) {
		it.number-align.x
	} else if text-dir == ltr {
		if it.number-align.x == start { left } else { right }
	} else if text-dir == rtl {
		if it.number-align.x == start { right } else { left }
	}

	let lines = replace-labels(
		to-lines(it),
		has-main-label,
		it.numbering,
		it.supplement,
		if it.has("label") and has-main-label { prefix + str(it.label) + "-" } else { prefix }
	)
	let line-num = sub-numbering and (not it.has("label") or has-main-label)
	if (it.has("label") and not has-main-label and lines.len() == 1) {
		return math.equation(it.body, .._prepare-equ-dict(it))
	}

	// Indices of numbered lines in this equation.
	let numbered = if sub-numbering and (not it.has("label") or has-main-label) {
		range(lines.len())
	} else {
		// Find lines that have a replaced label.
		lines.enumerate()
			.filter(((i, line)) => {
				if line.len() == 0 { return false }
				if line.last().func() != figure { return false }
				if line.last().body == none { return false }
				if line.last().body.func() != metadata { return false }
				return true
			})
			.map(((i, _)) => i)
	}
	
	// Get numbering
	sub-numbering = sub-numbering and (if it.has("label") { has-main-label } else { true })
	let main-num = [#figure(
			metadata(main-number),
			kind: math.equation,
			numbering: ((.._n) => numbering(it.numbering, ..main-number)),
			supplement: it.supplement
		)
		#if has-main-label {
			label(prefix + str(it.label))
		}
	]

	// Short-circuit for single-line equations.
	if lines.len() == 1 {
		if it.numbering == none { return it }
		if numbering(it.numbering, 1) == none { return it }

		let number = if numbered.len() > 0 {
			numbering(it.numbering, ..main-number)
		} else {
			// Step back counter as this equation should not be counted.
			counter(math.equation).update(n => n - 1)
		}

		return {
			// Update state to allow correct referencing.
			state.update(_ => sub-numbering)

			layout-line(
				lines.first(),
				number: number,
				number-align: number-align
			)
			main-num

			// Step back counter as we introducted an additional equation
			// that increased the counter by one.
			counter(math.equation).update(n => n - 1)
		}
	}

	// Calculate maximum width of all numberings in this equation.
	let max-number-width = if it.numbering == none { 0pt } else {
		calc.max(0pt, ..range(numbered.len()).map(i => {
			let nums = if sub-numbering and numbered.len() > 1 {
				main-number + (i + 1, )}
			else {
				main-number.slice(0, -1) + (main-number.at(-1) + i, )
			}
			measure(numbering(it.numbering, ..nums)).width
		}))
	}

	// Update state to allow correct referencing.
	state.update(_ => sub-numbering)

	// Layout equation as grid to allow page breaks.
	block(breakable: breakable,
		grid(
			columns: 1,
			row-gutter: par.leading,
			..realign(lines).enumerate().map(((i, line)) => {
				let sub-number = numbered.position(n => n == i)
				let number = if it.numbering == none {
					none
				} else if sub-number == none {
					// Step back counter as this equation should not be counted.
					counter(math.equation).update(n => n - 1)
				} else if sub-numbering and numbered.len() > 1 {
					numbering(it.numbering, ..main-number, sub-number + 1)
				} else {
					numbering(it.numbering, ..(main-number.slice(0, -1) + (main-number.at(-1) + sub-number, )))
				}

				layout-line(
					line,
					number: number,
					number-align: number-align,
					number-width: max-number-width
				)
			})
		)
	)
	main-num

	// Revert equation counter step(s).
	if it.numbering == none {
		// We converted a non-numbered equation into multiple empty-
		// numbered ones and thus increased the counter at every line.
		counter(math.equation).update(n => n - lines.len())
	} else {
		// Each line stepped the equation counter, but it should only
		// have been stepped once (when using sub-numbering). We also
		// always introduced an additional numbered equation that
		// stepped the counter.
		counter(math.equation).update(n => {
			n - if sub-numbering and numbered.len() > 1 { numbered.len() } else { 1 }
		})
	}
}


#import "state-notations.typ": notation, notations, notation-prefix, notation-full-suffix
// Add support for sub-numbering in references as well as notation references and CJK fix for references.
// The parameters shall be consistent with `equate`'s.
#let equate-ref(
	it, 
	unnumbered-label: "-",
	prefix: "eqt:",
	sep: "",
	sep-ref: true,
) = {
		assert(
			str(it.target) != unnumbered-label,
			message: "cannot reference equation without numbering."
		)
		if str(it.target).starts-with(notation-prefix) {
			let notation-key = str(it.target).slice(notation-prefix.len())
			let full = notation-key.ends-with(notation-full-suffix)
			notation-key = notation-key.trim(notation-full-suffix)
			if notation-key in notations.at(it.location()) {
				return notation(notation-key, full: full)
			}
		}
		if it.element != none {
			// equation ref
			let nums = counter(heading).at(it.element.location()).slice(0, 1)

			// Normal equation and re-aligned eqautions
			if it.element.func() == math.equation {
				nums = nums + counter(math.equation).at(it.element.location())
			} else {
				if it.element.func() != figure { return it }
				if it.element.kind != math.equation { return it }
				if it.element.body == none { return it }
				if it.element.body.func() != metadata { return it }
				// Display correct number, depending on whether sub-numbering was enabled.
				nums = if state.at(it.element.location()) {
					nums + it.element.body.value
				} else {
					// (3, 1): 3 + 1 - 1 = 3
					// (3, 2): 3 + 2 - 1 = 4
					nums + (it.element.body.value.first() + it.element.body.value.slice(1).sum(default: 1) - 1,)
				}
			}

			assert(
				it.element.numbering != none,
				message: "cannot reference equation without numbering."
			)
			assert(
				str(it.target).starts-with(prefix),
				message: "cannot reference equation without prefix \"" + prefix + "\"."
			)

			let num = numbering(it.element.numbering,
				..nums
			)
			let supplement = if it.supplement == auto {
				it.element.supplement
			} else {
				it.supplement
			}
			
			link(
				it.element.location(),
				if supplement not in ([], none) [#supplement#sep#num] else [#num]
			)
		} else if sep-ref {
			// CJK ref
			let key = it.citation.key
			let p = str(key).position(regex("\p{script=Han}"))
			if p == none or p == 0 {
				return it
			}
			let new-key = label(str(key).slice(0, p))
			let rest = str(key).slice(p)
			[#ref(new-key)#rest]
		} else {
			it
		}
}