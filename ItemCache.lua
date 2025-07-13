-- --------------------------------------------------------------------------------
-- Item cache for porperly requesting and caching items.
--
-- A cache can be created by calling ItemCache.new(). In this cache, items can be
-- requested by either calling ItemCache:getAsync(...), providing the item ID and
-- a callback function triggered when the item is cached successfully, or directly
-- by calling ItemCache:get(...). The latter will return nil if the item has not
-- been cached before.
-- --------------------------------------------------------------------------------
ItemCache = {}
ItemCache.queue = {}
ItemCache.cache = {}
ItemCache.event_frame = nil

-- Helper function to normalize item ID
local function normalize_item_id(item_id)
    return type(item_id) == "string" and tonumber(item_id) or item_id
end

function ItemCache.new()
    local itemCache = {}
    setmetatable(itemCache, ItemCache)
    ItemCache.__index = ItemCache

    itemCache.event_frame = CreateFrame("Frame")
    itemCache.event_frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
    itemCache.event_frame:SetScript("OnEvent", function(_, _, item_id, success) itemCache:event(item_id, success) end)

    return itemCache
end

function ItemCache:getAsync(item_id, callback_func)
    item_id = normalize_item_id(item_id)

    if self.cache[item_id] then
        callback_func(self.cache[item_id])
    else
        if not self.queue[item_id] then
            self.queue[item_id] = {id = item_id, funcs = {callback_func}}
        else
            table.insert(self.queue[item_id].funcs, callback_func)
        end

        if GetItemInfo(item_id) then
            self:event(item_id, true)
        end
    end
end

function ItemCache:get(item_id)
    item_id = normalize_item_id(item_id)
    return self.cache[item_id]
end

function ItemCache:loaded()
    return next(self.queue) == nil
end

function ItemCache:event(item_id, success)
    item_id = normalize_item_id(item_id)

    -- check if the item that triggered the event is available
    if self.queue[item_id] then
        local queued_item = self.queue[item_id]

        if success and GetItemInfo(item_id) then
            local name, _, quality, _, _, _, _, _, _ = GetItemInfo(item_id)
            local _, link = GetItemInfo(item_id)

            self.cache[item_id] = {
                id = item_id,
                name = name or "Unknown Item",
                quality = quality or 0,
                link = link or ("|Hitem:"..item_id..":0:0:0|h[?]"),
                icon = GetItemIcon(item_id)
            }

            for _, func in ipairs(queued_item.funcs) do
                func(self.cache[item_id])
            end
        end

        self.queue[item_id] = nil
    end
end

return ItemCache
