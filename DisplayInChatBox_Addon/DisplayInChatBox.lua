CTC_PLAYER_NAME_BTN = "COPY_PLAYER_NAME"
CTC_PLAYER_NAME_PROMPT = "Copy Name"

CTC_PLAYER_NAME_WITH_COMMAND_BTN = "COPY_PLAYER_NAME_WITH_COMMAND"
CTC_PLAYER_NAME_WITH_COMMAND_PROMPT = "Copy & Command"


Colors = {
    {
        title = 'LIGHTBLUE',
        color = 'cff00ccff',
    }, 
    {
        title = 'RED',
        color = 'cffff0000',
    }, 
    {
        title = 'GREEN',
        color = 'cff66ff00',
    }, 
}

local StartLine = '\124'
local EndLine = '\124r'

local DropdownMenuList = {"PLAYER","RAID_PLAYER","PARTY","TARGET","FRIEND",}

local function menuButtonFunction(self)	
    local PlayerName = getglobal("UIDROPDOWNMENU_INIT_MENU")
    local ChatFrame1EditBox = ChatFrame1EditBox
    ChatFrame1EditBox:SetFocus()

	if self.value == CTC_PLAYER_NAME_BTN then
        local command = PlayerName.name
        ChatFrame1EditBox:SetText(command)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(StartLine .. Colors[2].color .. "Displayed" .. EndLine .. " player name: " .. StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " ready to copy.")
        print("Text in chat: " .. StartLine .. Colors[3].color .. command .. EndLine)
    end

    if self.value == CTC_PLAYER_NAME_WITH_COMMAND_BTN then
        local command = "!check " .. PlayerName.name
        ChatFrame1EditBox:SetText(command)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(StartLine .. Colors[2].color .. "Displayed" .. EndLine .. " command: " .. StartLine .. Colors[1].color .. "!check" ..
         EndLine .." and player name: " .. StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " ready to copy.")
		print("Text in chat: " .. StartLine .. Colors[3].color .. command .. EndLine)		
	end

end

UnitPopupButtons[CTC_PLAYER_NAME_BTN] = {
    text = CTC_PLAYER_NAME_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3.png",
}

UnitPopupButtons[CTC_PLAYER_NAME_WITH_COMMAND_BTN] = {
    text = CTC_PLAYER_NAME_WITH_COMMAND_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.png",
}

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],CTC_PLAYER_NAME_WITH_COMMAND_BTN)
end

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],CTC_PLAYER_NAME_BTN)
end


hooksecurefunc("UnitPopup_OnClick",menuButtonFunction)