local DropdownMenuList = {"FRIEND", }

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

local function DisplayInChat(playerName, command)
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
end

local function SetMenuButtonFunction(self)	
    local unitMenu = getglobal("UIDROPDOWNMENU_INIT_MENU")
    local playerName = unitMenu.name
    local ChatFrame1EditBox = ChatFrame1EditBox

    for i = 1, length(BUTTONS) do
        if self.value == BUTTONS[i].title then
            DisplayInChat(playerName, BUTTONS[i].title)
        end
    end
end

for i = 1, length(BUTTONS) do
    UnitPopupButtons[BUTTONS[i].title] = {
        text = BUTTONS[i].title,
        dist = 0,
        icon = BUTTONS[i].icon,
    }

    for k,v in pairs(DropdownMenuList) do		
        table.insert(UnitPopupMenus[v], BUTTONS[i].title)
    end
end

hooksecurefunc("UnitPopup_OnClick", SetMenuButtonFunction)
