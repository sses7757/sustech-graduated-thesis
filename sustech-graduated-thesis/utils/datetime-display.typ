// 显示中文日期
#let datetime-display(date) = {
  date.display("[year] 年 [month padding:none] 月")
}

// 显示英文日期
#let datetime-en-display(date) = {
  date.display("[month repr:short], [year]")
}

// 显示中文大写年月
#let datetime-display-upper(date) = {
  let y = str(date.year()).split("").slice(1, -1)
  let m = str(date.month()).split("").slice(1, -1)
  let arr = ("〇", "一", "二", "三", "四", "五", "六", "七", "八", "九")
  let y = y.map(a => arr.at(int(a))).join()
  let m = m.map(a => arr.at(int(a))).join()
  y + "年" + m + "月"
}
