#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-numbering.typ": prefix-pagenum

// 研究生中文摘要页
#let abstract(
  // documentclass 传入的参数
  twoside: false,
  fonts: (:),
  // 其他参数
  keywords: (),
  outline-title: "摘　要",
  outlined: true,
  abstract-title-weight: "regular",
  body,
) = {
  fonts = 字体 + fonts

  set page(..prefix-pagenum())

  heading(level: 1, numbering: none, outlined: outlined, outline-title)
  [
    #set text(font: fonts.宋体, size: 字号.小四)
    #set par(first-line-indent: (amount: 2em, all: true))
    #body

    ~

    #set par(first-line-indent: (amount: 0pt, all: true), justify: false, hanging-indent: 4em)
    #let keywords-all = (("",) + keywords.intersperse("；")).sum()
    #text(font: fonts.黑体)[关键词]：#keywords-all
  ]
}
