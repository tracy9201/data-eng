import parse from 'html-react-parser'
import DOMPurify from 'dompurify'

export const testIfCurrency = (str) => {
  return /[$£€]/i.test(str)
}

// NOTE: handle convert data to hashmap and deal with duplicated label names
export const hashmapConvert = (map, label, value, duplicatedLabelCount) => {
  if (!map[label]) {
    map[label] =
      value === null || undefined // NOTE: add key-pair value when the label is not duplicated
        ? 'N/A'
        : value
  } else {
    if (!duplicatedLabelCount[label]) {
      duplicatedLabelCount[label] = 2
    } else {
      duplicatedLabelCount[label]++
    }
    map[`${label}(${duplicatedLabelCount[label]})`] =
      value === null || undefined // NOTE: add key-pair value when the label is duplicated
        ? 'N/A'
        : value
  }
  return map
}

export const parseSanitizedHTML = (html, opts = {}, replaceNode) => {
  return parse(DOMPurify.sanitize(html), {
    ...{
      replace: replaceNode,
    },
    ...opts,
  })
}
