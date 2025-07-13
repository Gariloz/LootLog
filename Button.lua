-- --------------------------------------------------------------------------------
-- Create a simple button with custom text.
--
-- Parameters:
--   name               Global name of the frame
--   parent             Parent frame object for placement within other frames
--   text               Caption of the button
--   width              Width of the frame in pixel
--   height             Height of the frame in pixel
--   click_callback     Callback function for clicks on items: <func>(button, item)
--
-- Returns the created button that is derived from Button
-- --------------------------------------------------------------------------------
function CreateButton(name, parent, text, width, height, click_callback)
    local button = CreateFrame("Button", name, parent)
    button:SetWidth(width)
    button:SetHeight(height)
    button:SetNormalFontObject("GameFontNormalSmall")
    button:SetText(text)

    local ntex = button:CreateTexture(nil, "BACKGROUND")
    ntex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    ntex:SetAllPoints()
    button:SetNormalTexture(ntex)

    local htex = button:CreateTexture(nil, "BACKGROUND")
    htex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
    htex:SetTexCoord(0, 0.625, 0, 0.6875)
    htex:SetAllPoints()
    button:SetHighlightTexture(htex)

    local ptex = button:CreateTexture(nil, "BACKGROUND")
    ptex:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
    ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    ptex:SetAllPoints()
    button:SetPushedTexture(ptex)

    if click_callback then
        button:SetScript("OnClick", function(self, ...) click_callback(self, ...) end)
    end

    return button
end