local Translations = {
    notify = {
        ['open'] = '打开包裹',
        ['drop'] = '放下包裹',
        ['pickup'] = '拿起包裹',
        ['check'] = '检查包裹',
        ['putin'] = '放入包裹',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
