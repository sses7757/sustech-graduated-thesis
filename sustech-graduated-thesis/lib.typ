#import "layouts/doc.typ": doc
#import "layouts/preface.typ": preface
#import "layouts/mainmatter.typ": mainmatter, arounds_default
#import "layouts/appendix.typ": appendix
#import "pages/fonts-display-page.typ": fonts-display-page
#import "pages/outline-page.typ": outline-page
#import "pages/nonfinal-cover.typ": nonfinal-cover
#import "pages/final-cover.typ": final-cover
#import "pages/decl-page.typ": decl-page
#import "pages/abstract.typ": abstract
#import "pages/abstract-en.typ": abstract-en
#import "pages/list-of-figures.typ": list-of-figures
#import "pages/list-of-tables.typ": list-of-tables
#import "pages/notation.typ": notation-page
#import "pages/acknowledgement.typ": acknowledgement
#import "utils/custom-cuti.typ": *
#import "pages/bilingual-bibliography.typ": bilingual-bibliography
#import "utils/custom-numbering.typ": custom-numbering
#import "utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "utils/style.typ": 字体, 字号
#import "utils/state-notations.typ": notation, notations
#import "utils/multi-line-equate.typ": show-figure, equate, equate-ref
#import "utils/eq-wrap.typ": eq-wrap

#import "@preview/unify:0.7.1": num as _num, qty as _qty, numrange as _numrange, qtyrange as _qtyrange
#let num(value) = _num(value, multiplier: "×", thousandsep: ",")
#let numrange(lower, upper) = _numrange(lower, upper, multiplier: "×", thousandsep: ",")
#let qty(value, unit, rawunit: false) = _qty(value, unit, rawunit: rawunit, multiplier: "×", thousandsep: ",")
#let qtyrange(lower, upper, unit, rawunit: false) = _qtyrange(
  lower,
  upper,
  unit,
  rawunit: rawunit,
  multiplier: "×",
  thousandsep: ",",
)

#import "@preview/lovelace:0.3.0": pseudocode as _pseudocode, pseudocode-list as _pseudocode-list
#let pseudocode(
  line-numbering: "1",
  line-number-supplement: "Line",
  stroke: 0.5pt + gray,
  indentation: 1em,
  hooks: 0pt,
  line-gap: .8em,
  booktabs-stroke: black + 1pt,
  booktabs: false,
  title: none,
  numbered-title: none,
  ..children,
) = {
  _pseudocode(
    line-numbering,
    line-number-supplement,
    stroke,
    indentation,
    hooks,
    line-gap,
    booktabs-stroke,
    booktabs,
    title,
    numbered-title,
    ..children.map(x => eq-warp(x)),
  )
}
#let pseudocode-list(..config, body) = {
  let transformed-body = eq-wrap(body)
  _pseudocode-list(..config, transformed-body)
}

#let indent = h(2em)

// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
#let documentclass(
  doctype: "final", // "proposal" | "midterm" | "final"，文章类型，默认为最终报告 final
  degree: "MEng", // 参考`degree-names.typ`
  academic: true, // 是否是学术学位
  twoside: true, // 双面模式，会加入空白页，便于打印
  anonymous: false, // 盲审模式
  bibliography: none, // 原来的参考文献函数
  math-font: "XITS Math", // 公式字体，应预先安装在系统中或放在根目录下
  slant-glteq: true, // 公式 <= >= 样式
  math-breakable: false, // 多行公式可否分割到多页
  arounds: arounds_default, // 公式不加空格的符号
  sep-ref: true, // 是否自动将@ref与其跟随的中文字符分开处理，使用true时应避免含有中文的label或bib
  fonts: (:), // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  fonts = 字体 + fonts
  info = (
    (
      title: ("基于Typst的", "南方科技大学学位论文"),
      title-en: "SUSTech Thesis Template for Typst",
      grade: "20XX",
      student-id: "1234567890",
      author: "张三",
      author-en: "Zhang San",
      department: "某系",
      department-en: "XX Department",
      major: "某专业",
      major-en: "XX Major",
      field: "某方向",
      field-en: "XX Field",
      supervisor: ("李四", "教授"),
      supervisor-en: "Professor Li Si",
      supervisor-ii: (),
      supervisor-ii-en: "",
      submit-date: datetime.today(),
      // 以下为研究生项
      defend-date: datetime.today(),
      confer-date: datetime.today(),
      bottom-date: datetime.today(),
      chairman: "某某某 教授",
      reviewer: ("某某某 教授", "某某某 教授"),
      clc: "O643.12",
      udc: "544.4",
      secret-level: "公开",
      supervisor-contact: "南方科技大学 广东省深圳市南山区学苑大道1088号",
      email: "xyz@mail.sustech.edu.cn",
      school-code: "14325",
    )
      + info
  )

  (
    // 将传入参数再导出
    doctype: doctype,
    degree: degree,
    twoside: twoside,
    anonymous: anonymous,
    fonts: fonts,
    info: info,
    // 页面布局
    doc: (..args) => {
      doc(
        ..args,
        info: info + args.named().at("info", default: (:)),
      )
    },
    preface: (..args) => {
      preface(
        twoside: twoside,
        ..args,
      )
    },
    mainmatter: (..args) => {
      mainmatter(
        slant-glteq: slant-glteq,
        math-font: math-font,
        arounds: arounds,
        sep-ref: true,
        twoside: twoside,
        display-header: true,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    appendix: (..args) => {
      appendix(
        twoside: twoside,
        ..args,
      )
    },
    // 字体展示页
    fonts-display-page: (..args) => {
      fonts-display-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    // 封面页，通过 type 分发到不同函数
    cover: (..args) => {
      if doctype == "proposal" or doctype == "midterm" {
        nonfinal-cover(
          is-midterm: doctype == "midterm",
          degree: degree,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "final" {
        final-cover(
          degree: degree,
          academic: academic,
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else {
        panic("not yet been implemented.")
      }
    },
    // 声明页，通过 type 分发到不同函数
    decl-page: (..args) => {
      if doctype == "final" {
        decl-page(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
    // 中文摘要页，通过 type 分发到不同函数
    abstract: (..args) => {
      if doctype == "final" {
        abstract(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
    // 英文摘要页，通过 type 分发到不同函数
    abstract-en: (..args) => {
      if doctype == "final" {
        abstract-en(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
    // 目录页
    outline-page: (..args) => {
      outline-page(
        twoside: twoside,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },
    // 插图目录页
    list-of-figures: (..args) => {
      if doctype == "final" {
        list-of-figures(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
    // 表格目录页
    list-of-tables: (..args) => {
      if doctype == "final" {
        list-of-tables(
          twoside: twoside,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
    // 符号表页
    notation-page: (..args) => {
      notation-page(
        twoside: twoside,
        ..args,
      )
    },
    // 参考文献页
    bilingual-bibliography: (..args) => {
      bilingual-bibliography(
        bibliography: bibliography,
        ..args,
      )
    },
    // 致谢页
    acknowledgement: (..args) => {
      if doctype == "final" {
        acknowledgement(
          anonymous: anonymous,
          twoside: twoside,
          ..args,
        )
      } else if doctype == "proposal" or doctype == "midterm" {
        []
      } else {
        panic("not yet been implemented.")
      }
    },
  )
}
