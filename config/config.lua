Config = {}

Config.Locale = 'cn' -- 语言 默认：简体中文（Chinese）

Config.Framework = 'qb' -- 目前仅支持 qb core / 希望有伙伴能帮助我适配 esx/vRP/...

Config.Target = 'qb' -- 目前这个配置毫无作用, 交互必须依赖于qb-target, 我并不喜欢使用 [E] 作为交互键

Config.Dispatch = {
    Enabled = true, -- 是否会触发报警？
    NightChance = 0.4, -- 触发报警的可能性, 输入 0.0 ~ 1.0, 显而易见的是 0.0 则永远不会触发 1.0 则必然会触发
    DayChance = 0.8, -- 触发报警的可能性, 输入 0.0 ~ 1.0, 显而易见的是 0.0 则永远不会触发 1.0 则必然会触发
    NightStart = 6, -- 开始夜晚（时）
    NightEnd = 5 -- 结束夜晚（时）
}
