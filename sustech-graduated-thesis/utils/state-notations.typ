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
#let notation-prefix = "no:"
#let notation-full-suffix = "-full"


// 创建或访问术语
// ### 参数
// - name-en: 英文名称
// - name-cn: 中文名称
// - abbr: 缩写，默认值为从name-en自动生成
// - full: 访问全称（true）或缩写（false）或无缩写全称（none）
// - args: 键值等内容
// ### 使用
// ```typst
// 创建：#notation("en", name-en: "English Name", name-cn: "中文名称", abbr: "EngN")
// 访问缩写：#notation("en")
// 创建无键值术语：#notation("", name-en: "English Name", name-cn: "中文名称")
// 或#notation("", "English Name", "中文名称")
// 或#notation("中文名称", "English Name") // 2个参数时顺序可互换
// ```
#let notation(..args, name-en: none, name-cn: none, abbr: auto, full: false) = {
  assert(
    args.pos().all(x => type(x) == str) and args.named().values().all(x => type(x) == str),
    message: "all arguments must be string",
  )
  assert(args.pos().len() <= 3 and args.pos().len() >= 1, message: "invalid number of positional argument(s)")

  // check named args
  let _ = if "name-en" in args.named() {
    name-en = if name-en == none { args.named().at("name-en") } else { name-en }
  }
  let _ = if "name-cn" in args.named() {
    name-cn = if name-cn == none { args.named().at("name-cn") } else { name-cn }
  }

  // check positional args
  let k = args.pos().at(0)
  let _ = if args.pos().len() == 1 { } else if args.pos().len() == 2 {
    if args.pos().at(0).contains(regex("\p{script=Han}")) {
      name-cn = if name-cn == none { args.pos().at(0) } else { name-cn }
      name-en = if name-en == none { args.pos().at(1) } else { name-en }
    } else {
      name-cn = if name-cn == none { args.pos().at(1) } else { name-cn }
      name-en = if name-en == none { args.pos().at(0) } else { name-en }
    }
    k = ""
  } else {
    if args.pos().at(1).contains(regex("\p{script=Han}")) {
      name-cn = if name-cn == none { args.pos().at(1) } else { name-cn }
      name-en = if name-en == none { args.pos().at(2) } else { name-en }
    } else {
      name-cn = if name-cn == none { args.pos().at(2) } else { name-cn }
      name-en = if name-en == none { args.pos().at(1) } else { name-en }
    }
    k = args.pos().at(0)
  }

  // evaluate
  let key = lower(k)
  let c = context (
    if key not in notations.get() {
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
        })
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
  if full == none or full or name-en != none { c + "）" } else { c }
}
