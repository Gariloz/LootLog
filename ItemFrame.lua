-- ItemFrame.lua
-- Creates frame for displaying items in LootLog

local ItemFrame = {}

-- Creates frame for displaying item list
function CreateItemFrame(name, parent, num_item_frames, frame_width, click_callback)
    -- Table for storing item buttons
    local tooltipButtons = setmetatable({}, {__mode = "k"})

    -- Frame for tracking Shift key
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

    -- Frame initialization
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

    -- Update item display
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
                    end

                    -- Show tooltip with proper quantity for TSM integration
                    if IsShiftKeyDown() then
                        -- Always pass the count when Shift is held, regardless of amount
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

    -- Scroll up
    function ItemFrame:scroll_up()
        if ItemFrame.scroll_pos > 1 then
            ItemFrame.scroll_pos = ItemFrame.scroll_pos - 1
            ItemFrame:update()
        end
    end

    -- Scroll down
    function ItemFrame:scroll_down()
        if ItemFrame.scroll_pos < #ItemFrame.items - ItemFrame.num_item_frames + 1 then
            ItemFrame.scroll_pos = ItemFrame.scroll_pos + 1
            ItemFrame:update()
        end
    end

    -- Set item list
    function ItemFrame:set_items(items)
        ItemFrame.items = items or {}
        ItemFrame.scroll_pos = 1
        ItemFrame:update()
    end

    -- Methods for LootLog compatibility
    function ItemFrame:SetItems(items)
        return ItemFrame:set_items(items)
    end

    function ItemFrame:GetNumItems()
        return #ItemFrame.items
    end

    -- Alias for compatibility
    ItemFrame.get_item_count = ItemFrame.GetNumItems

    initialize()
    return ItemFrame
end
