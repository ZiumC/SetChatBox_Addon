DTC_PLAYER_NAME_BTN = "COPY_PLAYER_NAME"
DTC_PLAYER_NAME_PROMPT = "Copy Name"

DTC_PLAYER_NAME_WITH_COMMAND_BTN = "COPY_PLAYER_NAME_WITH_COMMAND"
DTC_PLAYER_NAME_WITH_COMMAND_PROMPT = "Copy & Command"

DTC_PLAYER_NAME_APPEND_BTN = "COPY_PLAYER_NAME_AND_APPEND"
DTC_PLAYER_NAME_APPEND_PROMPT = "Copy & Append"

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

local DropdownMenuList = {"PLAYER","RAID_PLAYER","PARTY", "RAID" ,"TARGET","FRIEND", "VEHICLE", "SELF", "FOCUS", }

local function menuButtonFunction(self)	
    local PlayerName = getglobal("UIDROPDOWNMENU_INIT_MENU")
    local ChatFrame1EditBox = ChatFrame1EditBox

	if self.value == DTC_PLAYER_NAME_BTN then
        local command = PlayerName.name
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(command)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(StartLine .. Colors[2].color .. "Displayed" .. EndLine .. " player name: " .. StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " ready to copy.")
        print("Text in chat: " .. StartLine .. Colors[3].color .. command .. EndLine)
    end

    if self.value == DTC_PLAYER_NAME_WITH_COMMAND_BTN then
        local command = "!check " .. PlayerName.name
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(command)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(StartLine .. Colors[2].color .. "Displayed" .. EndLine .. " command: " .. StartLine .. Colors[1].color .. "!check" ..
         EndLine .." and player name: " .. StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " ready to copy.")
		print("Text in chat: " .. StartLine .. Colors[3].color .. command .. EndLine)		
	end

    if self.value == DTC_PLAYER_NAME_APPEND_BTN then
        local command = PlayerName.name
        ChatFrame1EditBox:SetFocus()
        ChatFrame1EditBox:SetText(ChatFrame1EditBox:GetText() .. command .. " ")
        print(StartLine .. Colors[2].color .. "Appended" .. EndLine .. " player name: " ..
        StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " to chat box.")
	end

end

UnitPopupButtons[DTC_PLAYER_NAME_BTN] = {
    text = DTC_PLAYER_NAME_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_3.png",
}

UnitPopupButtons[DTC_PLAYER_NAME_WITH_COMMAND_BTN] = {
    text = DTC_PLAYER_NAME_WITH_COMMAND_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.png",
}

UnitPopupButtons[DTC_PLAYER_NAME_APPEND_BTN] = {
    text = DTC_PLAYER_NAME_APPEND_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4.png",
}

for k,v in pairs(DropdownMenuList) do		
    table.insert(UnitPopupMenus[v],DTC_PLAYER_NAME_APPEND_BTN)
end

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],DTC_PLAYER_NAME_WITH_COMMAND_BTN)
end

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],DTC_PLAYER_NAME_BTN)
end


hooksecurefunc("UnitPopup_OnClick",menuButtonFunction)