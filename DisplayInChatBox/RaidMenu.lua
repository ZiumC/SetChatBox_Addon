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

local function split(text, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}
    for str in string.gmatch(text, "([^".. separator .."]+)") do
        table.insert(t, str)
    end
    return t
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

    if (raidPlayersCount > 0) and (IsInRaid() == true) then 
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

        -- display aviable options
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
    else
        UIDropDownMenu_SetText(dropDown, "You're not in RAID")
    end
end)

-- handling player options
function dropDown:DisplayInChat(playerName, command)

    UIDropDownMenu_SetText(dropDown, "Selected player: " .. playerName)
    ChatFrame1EditBox:SetFocus()

    if  command == BUTTONS[1].title then
        ChatFrame1EditBox:SetText(ChatFrame1EditBox:GetText() ..playerName .. " ")
        print(ColorText("Appended", "cffff0000") .. " player name: " .. ColorText(playerName, "cff00ccff") .. " to chat box.")
    end

    if  command == BUTTONS[2].title  then
        local command = BUTTONS[2].title
        ChatFrame1EditBox:SetText(command .. " " .. playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(ColorText("Displayed", "cffff0000") .. " command: " .. ColorText(command, "cff00ccff")
         .. " and player name: " .. ColorText(playerName, "cff00ccff")  .. " ready to copy.")
    end

    if  command == BUTTONS[3].title then
        ChatFrame1EditBox:SetText(playerName)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(ColorText("Displayed", "cffff0000") .. " player name: " .. ColorText(playerName, "cff00ccff")  .. " ready to copy.")
    end

    CloseDropDownMenus()
end


-- map button
local isRaidMenuHidded = true
local mapButtonAddon = LibStub("AceAddon-3.0"):NewAddon("DICB", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")
local database = LibStub("LibDataBroker-1.1"): NewDataObject("DatabaseObject", {
    type = "data source",
    OnTooltipShow = function(tooltip)
          tooltip:SetText("Display In Chat Box")
          tooltip:Show()
     end,
    icon = "Interface/Icons/inv_jewelry_stormpiketrinket_05",
    OnClick = function() 
        if isRaidMenuHidded == false then
            dropDown:Hide()
            isRaidMenuHidded = true
        else 
            dropDown:Show()
            isRaidMenuHidded = false
        end
    end,
})

function mapButtonAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("DatabaseObject", { 
        profile = { 
            minimap = { 
                hide = false, 
            }, 
        }, 
    }) 
    icon:Register("DatabaseObject", database, self.db.profile.minimap) 
end


-- on each raid update player count is increased
local function OnRaidRosterUpdate()
    UIDropDownMenu_SetText(dropDown, "Raid Players (" .. GetNumGroupMembers() .. ")")

    local isInRaid = IsInRaid()
    if isInRaid then
        dropDown:Show()
    else
        dropDown:Hide()
    end
end

dropDown:Hide()
dropDown:RegisterEvent("RAID_ROSTER_UPDATE")
dropDown:SetScript("OnEvent", OnRaidRosterUpdate)