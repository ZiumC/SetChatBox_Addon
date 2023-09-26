local raidPlayersCount = GetNumGroupMembers()
local maxRaidPlayers = 40

BUTTONS = {
    {
        title = "Append",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4.png"
    },
    {
        title = "!check",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.png"
    },
    {
        title = "Name",
        icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3.png"
    }
}

local function length(T)
    local count = 0
    for _ in pairs(T) do 
        count = count + 1 
    end
    return count
end

local function SetPlayerNameColorByClass(playerName, className)

    local startColorLine = '\124'
    local endColorLine = '\124r'

    if className == "Druid" then
        return startColorLine .. "cFFFFA500" .. playerName .. endColorLine
    end

    if className == "Paladin" then
        return startColorLine .. "cFFFFC0CB" .. playerName .. endColorLine
    end

    if className == "Death Knight" then
        return startColorLine .. "cFFFF0000" .. playerName .. endColorLine
    end

    if className == "Hunter" then
        return startColorLine .. "cFF90EE90" .. playerName .. endColorLine
    end

    if className == "Mage" then
        return startColorLine .. "cFFADD8E6" .. playerName .. endColorLine
    end

    if className == "Priest" then
        return startColorLine .. "cffffffff" .. playerName .. endColorLine
    end

    if className == "Rogue" then
        return startColorLine .. "cffffff00" .. playerName .. endColorLine
    end

    if className == "Shaman" then
        return startColorLine .. "cff0000ff" .. playerName .. endColorLine
    end

    if className == "Warlock" then
        return startColorLine .. "cFF800080" .. playerName .. endColorLine
    end

    if className == "Warrior" then
        return startColorLine .. "cFFD2B48C" .. playerName .. endColorLine
    end
end

-- create and configure dropdown menu
local dropDown = CreateFrame("FRAME", "RaidDropDown", UIParent, "UIDropDownMenuTemplate")
dropDown:EnableMouse(true)
dropDown:SetMovable(true)
dropDown:RegisterForDrag("LeftButton")
dropDown:SetScript("OnDragStart", dropDown.StartMoving)
dropDown:SetScript("OnDragStop", dropDown.StopMovingOrSizing)
dropDown:SetScript("OnHide", dropDown.StopMovingOrSizing)
dropDown:SetPoint("TOP")
UIDropDownMenu_SetWidth(dropDown, 200)
UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")

-- create and bind the function to dropdown menu
UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    raidPlayersCount = GetNumGroupMembers()
    UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")

    if (level or 1) == 1 then
        -- display raid players
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                info.text = SetPlayerNameColorByClass(name, fileName)
                info.func = self.ShowOptionWindow
                info.arg1 = name
                info.arg2 = fileName
                UIDropDownMenu_AddButton(info)
            end
        end
    end
end)

function dropDown:ShowOptionWindow(playerName, className)
    UIDropDownMenu_SetText(dropDown, "Selected player: " .. playerName)
    CloseDropDownMenus()

    -- create and configure window option
    local window = CreateFrame("FRAME", "PlayerOptionsFrame", UIParent)
    window:SetSize(150, 170)
    window:SetPoint("CENTER")
    window:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, 
        tileSize = 16, 
        edgeSize = 16, 
        insets = { 
            left = 4, 
            right = 4, 
            top = 4, 
            bottom = 4 
        }
    })
    window:SetBackdropColor(0, 0, 0, .5)
    window:SetBackdropBorderColor(0, 0, 0)
    window:EnableMouse(true)
    window:SetMovable(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    window:SetScript("OnHide", window.StopMovingOrSizing)
    window.text = window:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    window.text:SetPoint("CENTER", window, "CENTER", 0, 45)
    window.text:SetText("Actions for " .. SetPlayerNameColorByClass(playerName, className))

    -- create and add close btn
    local close = CreateFrame("BUTTON", "CloseBtn", window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT")
    close:SetScript("OnClick", function()
        window:Hide()
    end)

    local appendBtn = CreateFrame("BUTTON", "AppendBtn", window, "UIPanelButtonTemplate")
	appendBtn:SetPoint("TOP", window, "CENTER", 0, 20)
	appendBtn:SetWidth(75)
	appendBtn:SetHeight(25)
    appendBtn:SetText("Append")
    appendBtn:SetScript("OnClick", function()
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(ChatFrame1EditBox:GetText() .. playerName .. " ")
        print("\124cffff0000 Appended\124r player name: " .. SetPlayerNameColorByClass(playerName, className) .. " to chat box.")
        window:Hide()
    end)
	
    local checkBtn = CreateFrame("BUTTON", "CheckBtn", window, "UIPanelButtonTemplate")
	checkBtn:SetPoint("TOP", window, "CENTER", 0, -15)
	checkBtn:SetWidth(75)
	checkBtn:SetHeight(25)
    checkBtn:SetText("!check")
    checkBtn:SetScript("OnClick", function()
        local command = "!check"
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(command .. " " .. playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print("\124cffff0000 Displayed\124r command: \124cff00ccff" .. command 
        .. "\124r and player name: " .. SetPlayerNameColorByClass(playerName, className) .. " ready to copy.")
        window:Hide()
    end)

    local nameBtn = CreateFrame("BUTTON", "CheckBtn", window, "UIPanelButtonTemplate")
	nameBtn:SetPoint("TOP", window, "CENTER", 0,-50)
	nameBtn:SetWidth(75)
	nameBtn:SetHeight(25)
    nameBtn:SetText("Name")
    nameBtn:SetScript("OnClick", function()
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print("\124cffff0000 Displayed\124r player name: " .. SetPlayerNameColorByClass(playerName, className) .. " ready to copy.")
        window:Hide()
    end)

end