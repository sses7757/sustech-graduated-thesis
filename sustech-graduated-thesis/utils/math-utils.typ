#let svec(cont) = {
  $accent(#cont, ->, size: #75%)$
}

#let _empty-l = math.class("opening", [])
#let _empty-r = math.class("closing", [])

#let sfrac(num, denom) = {
  $lr(#_empty-l #num mid(\/) #denom #_empty-r)$
}

#let hide(value) = context h(measure(value).width)
