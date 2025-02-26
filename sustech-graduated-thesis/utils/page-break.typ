#let _page-break() = {
  set page(header: none, footer: none)
  [~]
  pagebreak(weak: true, to: "odd")
}

#let page-break(twoside: true) = {
  if twoside {
    context {
      let loc = here()
      let pn = counter(page).at(loc).at(0)
      if calc.rem(pn, 2) == 1 {
        _page-break()
      }
    }
  }
}