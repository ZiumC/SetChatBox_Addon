CTC_PLAYER_NAME_BTN = "COPY_PLAYER_NAME"
CTC_PLAYER_NAME_PROMPT = "Copy"

local DropdownMenuList = {"PLAYER","RAID_PLAYER","PARTY","TARGET","FRIEND",}

local function menuButtonFunction(self)	
	if self.value == CTC_PLAYER_NAME_BTN then
		print("Target added to list")		
	end
end

UnitPopupButtons[CTC_PLAYER_NAME_BTN] = {
	text = CTC_PLAYER_NAME_PROMPT,
	dist = 0,
	icon = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1.png",
}

for k,v in pairs(DropdownMenuList) do		
	table.insert(UnitPopupMenus[v],CTC_PLAYER_NAME_BTN)
end

hooksecurefunc("UnitPopup_OnClick",menuButtonFunction)