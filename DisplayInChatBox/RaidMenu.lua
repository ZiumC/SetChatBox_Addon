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
UIDropDownMenu_SetWidth(dropDown, 170)
UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")

local groups = {}
-- create and bind the function to dropdown menu
UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    raidPlayersCount = GetNumGroupMembers()
    UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")

    local maxSubGroup = 0
    if (level or 1) == 1 then
        -- display raid players
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)

            if name ~= nil then
                groups[i] = subgroup .. " " .. name
            end

            if subgroup > maxSubGroup then
                maxSubGroup = subgroup
            end
        end

        for j = 1, maxSubGroup do
            info.text, info.hasArrow = "Group " .. j, true
            UIDropDownMenu_AddButton(info)
        end
    else
        -- split and get parrent button name
        local parrentBtnName = getglobal("UIDROPDOWNMENU_MENU_VALUE")
        local count = 0
        local playerGroup = 0

        for split in string.gmatch(parrentBtnName, "%S+") do
            count = count + 1
            if count == 2 then
                playerGroup = split
            end
        end
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                if playerGroup == (subgroup .."") then
                    info.text = SetPlayerNameColorByClass(name, fileName)
                    info.func = self.ShowOptionWindow
                    info.arg1 = name
                    info.arg2 = fileName
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end
end)

function dropDown:ShowOptionWindow(playerName, className)
    UIDropDownMenu_SetText(dropDown, "Selected player: " .. playerName)
    CloseDropDownMenus()

    -- create and configure window option
    local window = CreateFrame("FRAME", "PlayerOptionsFrame", UIParent)
    window:SetSize(170, 170)
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

    -- create player options buttons
    local yPos = 30
    for i = 1, length(BUTTONS) do
        local btnName = BUTTONS[i].title .. "Btn"

        local button = CreateFrame("BUTTON", btnName, window, "UIPanelButtonTemplate")
        button:SetPoint("TOP", window, "CENTER", 0, yPos)
        yPos = yPos - 35
        button:SetWidth(100)
	    button:SetHeight(27)
        button:SetText(BUTTONS[i].title)

        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetTexture(BUTTONS[i].icon)
        icon:SetSize(16, 16) 
        icon:SetPoint("RIGHT", button, "RIGHT", -4, 0)

        button:SetScript("OnClick", function()
            ChatFrame1EditBox:SetFocus()

            if  btnName == "AppendBtn" then
                ChatFrame1EditBox:SetText(ChatFrame1EditBox:GetText() .. playerName .. " ")
                print("\124cffff0000 Appended\124r player name: " .. SetPlayerNameColorByClass(playerName, className) .. " to chat box.")
            end

            if  btnName == "!checkBtn" then
                local command = BUTTONS[i].title
                ChatFrame1EditBox:SetText(command .. " " .. playerName)
                ChatFrame1EditBox:HighlightText(0, -1)
                print("\124cffff0000 Displayed\124r command: \124cff00ccff" .. command 
                .. "\124r and player name: " .. SetPlayerNameColorByClass(playerName, className) .. " ready to copy.")
            end

            if  btnName == "NameBtn" then
                ChatFrame1EditBox:SetText(playerName)
                ChatFrame1EditBox:HighlightText(0, -1)
                print("\124cffff0000 Displayed\124r player name: " .. SetPlayerNameColorByClass(playerName, className) .. " ready to copy.")
            end
            
            UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")
            window:Hide()
        end)
    end
end
