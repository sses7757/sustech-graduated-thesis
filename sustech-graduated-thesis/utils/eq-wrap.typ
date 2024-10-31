#let arounds_default = "、，。！？…；：—‘’“”（）【】《》~!@#$%^&*()-_=+/*[]{}|\\:;'\"<>,./? 　"

	// 3.5 inline 公式两边的空格，必须放在最后
	#let eq-wrap(cont, arounds: arounds_default) = {
		if not cont.has("children") {
			return cont
		}
		let cont-fn = cont.func()
		let cont-fs = cont.fields()
		let _ = cont-fs.remove("children")

		let map-fn = ((n, elem)) => {
			if elem.func() in (list.item, enum.item, figure, table, table.cell) {
				let fs = elem.fields()
				let _ = fs.remove("body")
				let lab = if "label" in fs {fs.remove("label")}
				let _ = if "caption" in fs {fs.insert("caption", eq-wrap(elem.caption.body))}
				let fn = elem.func()
				let wrapped = eq-wrap(elem.body)
				if lab != none and elem.func() in (list.item, enum.item, figure) {
					[#fn(wrapped, ..fs)#lab]
				} else {
					fn(wrapped, ..fs)
				}
			} else {
				if (elem.func() == math.equation and elem.block == false) or repr(elem) == "context()" {
					if n > 0 {
						if cont.children.at(n - 1).has("text") {
							let prev = cont.children.at(n - 1).text.last()
							if not arounds.contains(prev)  {
								[ ]
							}
						}
					}
					elem
					if n < cont.children.len() - 1 {
						if cont.children.at(n + 1).has("text") {
							let next = cont.children.at(n + 1).text.first()
							if not arounds.contains(next) {
								[ ]
							}
						}
					}
				} else {
					elem
				}
			}
		}

		if repr(cont-fn) == "sequence" {
			for (n, elem) in cont.children.enumerate() {
				map-fn((n, elem))
			}
		} else {
			let new-child = cont.children.enumerate().map(map-fn)
			cont-fn(..new-child, ..cont-fs)
		}
	}