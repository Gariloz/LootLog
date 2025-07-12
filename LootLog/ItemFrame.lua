-- --------------------------------------------------------------------------------
-- Create a frame designed for showing items in a scrollable list.
-- Compatible with WoW 3.3.5a
-- Parameters:
--   name               Global name of the frame
--   parent             Parent frame object for placement within other frames
--   num_item_frames    Number of items that can be simultaneously shown
--   frame_width        Width of the frame in pixel (minimum: 100)
--   click_callback     Callback function for clicks on items: <func>(button, item)
-- Returns the created frame that is derived from Frame
-- --------------------------------------------------------------------------------
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

    -- Настройки
    ItemFrame.num_item_frames = num_item_frames
    ItemFrame.frame_width = math.max(100, frame_width)
    ItemFrame.item_height = 20

    -- Колбэк на клик
    ItemFrame.click_callback = click_callback

    -- Хранилище элементов
    ItemFrame.background = {}
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

        ItemFrame.ScrollFrame = CreateFrame("ScrollFrame", name .. "ScrollFrame", ItemFrame, "FauxScrollFrameTemplate")
        ItemFrame.ScrollFrame:SetWidth(ItemFrame.frame_width - 22)
        ItemFrame.ScrollFrame:SetHeight(ItemFrame.num_item_frames * ItemFrame.item_height)
        ItemFrame.ScrollFrame:SetPoint("TOPLEFT", 0, 0)
    end

    initialize()

-- Обновление списка
local update = function()
    local max_scroll_pos = math.max(1, #ItemFrame.items - ItemFrame.num_item_frames + 1)
    if ItemFrame.scroll_pos > max_scroll_pos then
        ItemFrame.scroll_pos = max_scroll_pos
    end

    FauxScrollFrame_Update(ItemFrame.ScrollFrame, #ItemFrame.items, ItemFrame.num_item_frames, ItemFrame.item_height)

    for i = 1, ItemFrame.num_item_frames do
        local index = ItemFrame.scroll_pos - 1 + i
        if index <= #ItemFrame.items then
            local item = ItemFrame.items[index]

            local item_color = {GetItemQualityColor(item.quality)}

            ItemFrame.item_lines[i].icon:SetTexture(GetItemIcon(item.id))

            ItemFrame.item_lines[i].icon_btn:SetAttribute("type", "item")
            ItemFrame.item_lines[i].icon_btn:SetAttribute("item", item.id)

            ItemFrame.item_lines[i].icon_btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:ClearLines()

                local itemId = self:GetAttribute("item")
                if not itemId then return end

                local count = item.amount or 1
                local link = "item:" .. itemId .. ":0:0:0"

                if IsShiftKeyDown() and count > 1 then
                    if GameTooltip.SetItemByID then
                        GameTooltip:SetItemByID(itemId, count)
                    else
                        GameTooltip:SetHyperlink(link, count)
                    end
                else
                    GameTooltip:SetHyperlink(link)
                end

                GameTooltip:Show()
            end)

            ItemFrame.item_lines[i].icon_btn:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            ItemFrame.item_lines[i].icon_btn:SetScript("OnMouseUp", function(self, button)
                click_callback(button, self:GetAttribute("item"))
                GameTooltip:Hide()
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:Show()
            end)

            ItemFrame.item_lines[i].name:SetTextColor(unpack(item_color))
            ItemFrame.item_lines[i].name:SetText(item.name .. " x" .. (item.amount or 1))

            tooltipButtons[ItemFrame.item_lines[i].icon_btn] = true
            ItemFrame.item_lines[i]:Show()
        else
            ItemFrame.item_lines[i]:Hide()
        end
    end
end

    function ItemFrame:GetFrameSize()
        return ItemFrame.frame_width, ItemFrame.num_item_frames * ItemFrame.item_height
    end

    function ItemFrame:GetNumItems()
        return #ItemFrame.items
    end

    function ItemFrame:ClearItems()
        for i = #ItemFrame.items, 1, -1 do
            table.remove(ItemFrame.items, i)
        end
        update()
    end

    function ItemFrame:SetItems(items)
        ItemFrame.items = items
        update()
    end

    local function update_scroll()
        FauxScrollFrame_Update(ItemFrame.ScrollFrame, #ItemFrame.items, ItemFrame.num_item_frames, ItemFrame.item_height)
        ItemFrame.scroll_pos = FauxScrollFrame_GetOffset(ItemFrame.ScrollFrame) + 1
        update()
    end

    ItemFrame.ScrollFrame:SetScript("OnVerticalScroll", function(_, offset)
        FauxScrollFrame_OnVerticalScroll(ItemFrame.ScrollFrame, offset, ItemFrame.item_height, update_scroll)
    end)

    return ItemFrame
end