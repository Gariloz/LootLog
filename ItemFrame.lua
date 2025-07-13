-- ItemFrame.lua
-- Создает фрейм для отображения предметов в LootLog

local ItemFrame = {}

-- Создает фрейм для отображения списка предметов
function CreateItemFrame(name, parent, num_item_frames, frame_width, click_callback)
    -- Таблица для хранения кнопок предметов
    local tooltipButtons = setmetatable({}, {__mode = "k"})

    -- Фрейм для отслеживания Shift
    local modifierWatcher = CreateFrame("Frame")
    modifierWatcher:RegisterEvent("MODIFIER_STATE_CHANGED")
    modifierWatcher:SetScript("OnEvent", function(_, event, key)
        if event == "MODIFIER_STATE_CHANGED" and (key == "LSHIFT" or key == "RSHIFT") then
            for btn in pairs(tooltipButtons) do
                if btn:IsMouseOver() and GameTooltip:IsOwned(btn) then
                    btn:GetScript("OnEnter")(btn)
                end
            end
        end
    end)

    local ItemFrame = CreateFrame("Frame", name, parent)
    ItemFrame.num_item_frames = num_item_frames
    ItemFrame.frame_width = frame_width
    ItemFrame.item_height = 20
    ItemFrame.item_lines = {}
    ItemFrame.items = {}
    ItemFrame.scroll_pos = 1

    -- Инициализация фрейма
    local function initialize()
        ItemFrame:SetWidth(ItemFrame.frame_width)
        ItemFrame:SetHeight(ItemFrame.num_item_frames * ItemFrame.item_height)

        ItemFrame.background = ItemFrame:CreateTexture(nil, "BACKGROUND")
        ItemFrame.background:SetAllPoints(ItemFrame)
        ItemFrame.background:SetColorTexture(0.2, 0.2, 0.2, 0.5)

        for i = 1, ItemFrame.num_item_frames do
            local item_line = CreateFrame("Frame", name .. "ItemFrame#" .. i, ItemFrame)
            item_line:SetPoint("TOPLEFT", 0, -(i - 1) * ItemFrame.item_height)
            item_line:SetWidth(ItemFrame.frame_width)
            item_line:SetHeight(ItemFrame.item_height)

            item_line.icon = item_line:CreateTexture(nil, "BACKGROUND")
            item_line.icon:SetPoint("TOPLEFT", 0, 0)
            item_line.icon:SetWidth(ItemFrame.item_height)
            item_line.icon:SetHeight(ItemFrame.item_height)

            item_line.icon_btn = CreateFrame("Button", name .. "ItemIconBtn#" .. i, item_line)
            item_line.icon_btn:SetPoint("TOPLEFT", 0, 0)
            item_line.icon_btn:SetWidth(ItemFrame.frame_width - 20)
            item_line.icon_btn:SetHeight(ItemFrame.item_height)

            item_line.name = item_line:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmallLeft")
            item_line.name:SetPoint("LEFT", ItemFrame.item_height + 5, 0)
            item_line.name:SetWidth(ItemFrame.frame_width - ItemFrame.item_height - 5 - 20)

            table.insert(ItemFrame.item_lines, item_line)
        end
    end

    -- Обновление отображения предметов
    function ItemFrame:update()
        for i = 1, ItemFrame.num_item_frames do
            local item_index = ItemFrame.scroll_pos + i - 1
            local item = ItemFrame.items[item_index]

            if item then
                ItemFrame.item_lines[i]:Show()
                ItemFrame.item_lines[i].name:SetText(item.name .. " x" .. item.amount)
                ItemFrame.item_lines[i].icon:SetTexture(GetItemIcon(item.id))

                ItemFrame.item_lines[i].icon_btn:SetAttribute("type", "item")
                ItemFrame.item_lines[i].icon_btn:SetAttribute("item", item.id)

                ItemFrame.item_lines[i].icon_btn:SetScript("OnEnter", function(self)
                    tooltipButtons[self] = true

                    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                    GameTooltip:ClearLines()

                    local itemId = self:GetAttribute("item")
                    if not itemId then return end

                    local count = item.amount or 1
                    local link = "item:" .. itemId .. ":0:0:0"
                    local itemString = "item:" .. itemId

                    -- TSM Integration: Set current item ID for money formatting hooks
                    if IsShiftKeyDown() then
                        _G.LootLogCurrentItemID = itemId
                        print("LootLog: Set current item ID to", itemId, "for TSM integration")
                    end

                    -- Show tooltip with proper quantity for TSM integration
                    if IsShiftKeyDown() then
                        -- Always pass the count when Shift is held, regardless of amount
                        if GameTooltip.SetItemByID then
                            GameTooltip:SetItemByID(itemId, count)
                        else
                            GameTooltip:SetHyperlink(link, count)
                        end
                        print("LootLog: Showing tooltip for item", itemId, "with count", count)
                    else
                        GameTooltip:SetHyperlink(link)
                    end

                    GameTooltip:Show()
                end)

                ItemFrame.item_lines[i].icon_btn:SetScript("OnLeave", function(self)
                    tooltipButtons[self] = nil
                    _G.LootLogCurrentItemID = nil  -- Clear current item ID
                    GameTooltip:Hide()
                end)

                ItemFrame.item_lines[i].icon_btn:SetScript("OnMouseUp", function(self, button)
                    click_callback(button, self:GetAttribute("item"))
                    GameTooltip:Hide()
                    GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                    GameTooltip:Show()
                end)
            else
                ItemFrame.item_lines[i]:Hide()
            end
        end
    end

    -- Прокрутка вверх
    function ItemFrame:scroll_up()
        if ItemFrame.scroll_pos > 1 then
            ItemFrame.scroll_pos = ItemFrame.scroll_pos - 1
            ItemFrame:update()
        end
    end

    -- Прокрутка вниз
    function ItemFrame:scroll_down()
        if ItemFrame.scroll_pos < #ItemFrame.items - ItemFrame.num_item_frames + 1 then
            ItemFrame.scroll_pos = ItemFrame.scroll_pos + 1
            ItemFrame:update()
        end
    end

    -- Установка списка предметов
    function ItemFrame:set_items(items)
        ItemFrame.items = items or {}
        ItemFrame.scroll_pos = 1
        ItemFrame:update()
    end

    -- Методы для совместимости с LootLog
    function ItemFrame:SetItems(items)
        return ItemFrame:set_items(items)
    end

    function ItemFrame:GetNumItems()
        return #ItemFrame.items
    end

    -- Получение количества предметов
    function ItemFrame:get_item_count()
        return #ItemFrame.items
    end

    initialize()
    return ItemFrame
end
