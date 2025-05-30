#import "../utils/multi-line-equate.typ": show-figure
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/eq-wrap.typ": eq-wrap, arounds_default

// 后记，重置 heading 计数器
#let appendix(
  numbering: custom-numbering.with(first-level: "", depth: 4, "A.1 "),
  // figure 计数
  show-figure: show-figure.with(numbering: "A-1"),
  // 重置计数
  reset-counter: true,
  twoside: true,
  it,
) = {
  set heading(numbering: numbering)
  if reset-counter {
    counter(heading).update(0)
  }
  // 设置 figure 的编号
  show figure: show-figure
  // 设置 equation 的编号
  set math.equation(numbering: "(A-1a)")
  show: eq-wrap.with(arounds: arounds_default)
  it
}
