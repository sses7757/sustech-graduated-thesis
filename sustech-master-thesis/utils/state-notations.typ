#import "style.typ": 字体

#let print-notations(abbr, name-en, name-cn) = {
	if abbr == none {
		none
	} else {
		([#abbr], [#name-cn（#name-en）])
	}
}

#let smart-abbr(name-en, name-cn, abbr) = {
	if abbr == none or abbr != auto {
		abbr
	} else {
		let words = name-en.split(regex("[ \-]"))
		let uppercase-count = words.map(w => w.matches(regex("[A-Z]")).len()).sum(default: 0)
		if uppercase-count <= 1 {
			words.map(w => upper(w.at(0))).sum(default: "")
		} else {
			words.map(w => w.matches(regex("[A-Z]")).map(m => m.text).sum(default: "")).sum(default: "")
		}
	}
}

#let notations = state("notations", (:))

#let notation(k, name-en: none, name-cn: none, abbr: auto, full: false) = {
	let key = lower(k)
	let c = context (
		if key not in notations.get()	{
			if name-en == none or name-cn == none {
				panic("Notation key \"" + key + "\" not found! Must provide name.")
			}
			let name = name-en
			if name-en.matches(regex("[A-Z]")).len() == 0 {
				name = name-en.split(" ").map(w => upper(w.at(0)) + w.slice(1)).join(" ")
				name = name.split("-").map(w => upper(w.at(0)) + w.slice(1)).join("-")
			}
			if key == "" {
				[#text(font: 字体.楷体, name-cn)（#name]
			} else {
				let value = (smart-abbr(name-en, name-cn, abbr), name, name-cn)
				let ttt = notations.update(n => {
						n.insert(key, value)
						n
					}
				)
				[#text(font: 字体.楷体, value.at(2))（#value.at(1)，#value.at(0)#ttt]
			}
		} else {
			let value = notations.get().at(key)
			if full == true {
				[#text(font: 字体.楷体, value.at(2))（#value.at(1)，#value.at(0)]
			} else if full == false {
				[#value.at(0)]
			} else {
				[#text(font: 字体.楷体, value.at(2))（#value.at(1)]
			}
		}
	)
	if full == none or full or name-en != none {c + "）"} else {c}
}