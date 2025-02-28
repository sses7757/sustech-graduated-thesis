// 双端对其一段小文本，常用于表格的中文 key
#let justify-text(with-tail: false, tail: "：", split-by: " ", text-args: none, body) = {
  let splitted = body.split(split-by).filter(it => it != "")
  let ret = if with-tail and tail != "" {
    stack(dir: ltr, stack(dir: ltr, spacing: 1fr, ..splitted), tail)
  } else {
    stack(dir: ltr, spacing: 1fr, ..splitted)
  }
  if text-args != none {
    ret = text(..text-args, ret)
  }
  ret
}
