#let hide-info(body, hide: true) = {
  if hide {
    context box(fill: black, inset: 0pt, radius: 0pt, stroke: none, outset: 0pt, clip: false, height: measure(body).height, width: measure(body).width)[-]
  } else {
    body
  }
}