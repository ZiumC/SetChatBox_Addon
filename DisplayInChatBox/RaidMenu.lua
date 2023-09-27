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

local function ColorText(text, color)

    local startColorLine = '\124'
    local endColorLine = '\124r'

    return startColorLine .. color .. text .. endColorLine

end

local function SetPlayerNameColorByClass(playerName, className)
    if className == "Paladin" then
        return ColorText(playerName, "cFFFFC0CB")
    end

    if className == "Death Knight" then
        return ColorText(playerName, "cFFFF0000")
    end

    if className == "Druid" then
        return ColorText(playerName, "cFFFFA500")
    end

    if className == "Hunter" then
        return ColorText(playerName, "cFF90EE90")
    end

    if className == "Mage" then
        return ColorText(playerName, "cFFADD8E6")
    end

    if className == "Priest" then
        return ColorText(playerName, "cffffffff")
    end

    if className == "Rogue" then
        return ColorText(playerName, "cffffff00")
    end

    if className == "Shaman" then
        return ColorText(playerName, "cff0000ff")
    end

    if className == "Warlock" then
        return ColorText(playerName, "cFF800080")
    end

    if className == "Warrior" then
        return ColorText(playerName, "cFFD2B48C")
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
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                groups[i] = subgroup .. " " .. name
            end
            if subgroup > maxSubGroup then
                maxSubGroup = subgroup
            end
        end
        
        -- display raid groups
        for j = 1, maxSubGroup do
            info.text, info.hasArrow = "Group " .. j, true
            UIDropDownMenu_AddButton(info)
        end
    end

    if level == 2 then
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

        -- assign players to raid group
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                if playerGroup == (subgroup .. "") then
                    info.text = SetPlayerNameColorByClass(name, fileName)
                    info.value = name
                    info.hasArrow = true
                    info.arg1 = name
                    info.arg2 = fileName
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end

    if level == 3 then
        local parrentBtnName = getglobal("UIDROPDOWNMENU_MENU_VALUE")
        for i = 1, length(BUTTONS) do
            info.text, info.icon = BUTTONS[i].title, BUTTONS[i].icon
            info.func = self.DisplayInChat
            info.arg1 = parrentBtnName
            info.arg2 = BUTTONS[i].title
            UIDropDownMenu_AddButton(info, level)
        end
        
    end
end)

function dropDown:DisplayInChat(playerName, command)

    UIDropDownMenu_SetText(dropDown, "Selected player: " .. playerName)
    ChatFrame1EditBox:SetFocus()

    if  command == BUTTONS[1].title then
        ChatFrame1EditBox:SetText(ChatFrame1EditBox:GetText() ..playerName .. " ")
        print("\124cffff0000 Appended\124r player name: \124cff00ccff" .. playerName .. "\124r to chat box.")
    end

    if  command == BUTTONS[2].title  then
        local command = BUTTONS[2].title
        ChatFrame1EditBox:SetText(command .. " " .. playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print("\124cffff0000 Displayed\124r command: \124cff00ccff" .. command 
        .. "\124r and player name: \124cff00ccff" .. playerName .. "\124r ready to copy.")
    end

    if  command == BUTTONS[3].title then
        ChatFrame1EditBox:SetText(playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print("\124cffff0000 Displayed\124r player name: \124cff00ccff" .. playerName .. "\124r ready to copy.")
    end

    CloseDropDownMenus()
end
