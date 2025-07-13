-- LootLog_Exclusions.lua
LootLog_Exclusions = {
    roll_keywords = {
        ["ruRU"] = {
            -- Основные слова для исключения
            "разыгрывается", "результат", "выигрывает", 
            "не откажусь", "нужно", "мне это нужно", 
            "отказывается", "отказался", "распылить", 
            "вы выиграли"
        },
        ["enUS"] = {
            "roll", "result", "wins", "need", "greed", 
            "passed", "disenchant", "declined", 
            "chosen", "refused loot"
        },
        ["deDE"] = {
            "würfel", "ergebnis", "gewinnt", "bedarf", "gier",
            "abgelehnt", "zerzaubern", "entschieden für", 
            "verweigert loot"
        },
        ["frFR"] = {
            "lancer", "résultat", "remporte", "nécessité", "cupide",
            "refusé", "désenchanter", "a choisi", 
            "a refusé le butin"
        },
        ["esES"] = {
            "lanza", "resultado", "gana", "necesidad", "codicia",
            "rechazado", "desencantar", "ha elegido", 
            "ha rechazado el botín"
        },
        ["zhCN"] = {
            "掷骰子", "结果", "赢得", "需要", "贪婪", 
            "已拒绝", "分解", "已选择", "已放弃获取"
        }
    },
    roll_patterns = {
        "x%d+", -- количество (например, "x20")
        ":%s*%d+", -- число после двоеточия (например, "Результат: 100")
        "[%s%p][%d]+[%s%p]", -- любое число с пробелами/знаками
        "выбирает ['\"]распылить['\"]", -- русский формат
        "a choisi désenchanter", -- французский
        "entschieden für zerzaubern", -- немецкий
        "chose to disenchant", -- английский
        "has chosen to disenchant", -- английский
        "has selected", -- английский
        "selected", -- английский
        "selected for loot" -- английский
    }
}