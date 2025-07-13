-- LootLog_Exclusions.lua
LootLog_Exclusions = {
    roll_keywords = {
        ["ruRU"] = {
            -- Main words for exclusion
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
        "x%d+", -- quantity (e.g., "x20")
        ":%s*%d+", -- number after colon (e.g., "Result: 100")
        "[%s%p][%d]+[%s%p]", -- any number with spaces/punctuation
        "выбирает ['\"]распылить['\"]", -- Russian format
        "a choisi désenchanter", -- French
        "entschieden für zerzaubern", -- German
        "chose to disenchant", -- English
        "has chosen to disenchant", -- English
        "has selected", -- English
        "selected", -- English
        "selected for loot" -- English
    }
}