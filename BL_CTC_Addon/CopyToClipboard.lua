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
}

local StartLine = '\124'
local EndLine = '\124r'

local DropdownMenuList = {"PLAYER","RAID_PLAYER","PARTY","TARGET","FRIEND",}

local function menuButtonFunction(self)	
    local PlayerName = getglobal("UIDROPDOWNMENU_INIT_MENU")
    local ChatFrame1EditBox = ChatFrame1EditBox
    ChatFrame1EditBox:SetFocus()
	if self.value == CTC_PLAYER_NAME_BTN then
        ChatFrame1EditBox:SetText(PlayerName.name)
        ChatFrame1EditBox:HighlightText(0, -1)
        print(StartLine .. Colors[2].color .. "Displayed" .. EndLine .. " player name: " .. StartLine .. Colors[1].color .. PlayerName.name .. EndLine .. " ready to copy.")	
	end
    if self.value == CTC_PLAYER_NAME_WITH_COMMAND_BTN then
		print("Target added to list")		
	end
end

local function CopyTextToClipboard(editBox)
    local textToCopy = editBox:GetText()
    if textToCopy then
        if textToCopy ~= "" then
            -- Skopiuj tekst do schowka
            EditBoxCopyTextToClipboard(editBox)
        end
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
	table.insert(UnitPopupMenus[v],CTC_PLAYER_NAME_BTN)
end

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],CTC_PLAYER_NAME_WITH_COMMAND_BTN)
end

hooksecurefunc("UnitPopup_OnClick",menuButtonFunction)