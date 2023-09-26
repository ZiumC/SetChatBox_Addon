local raidPlayersCount = GetNumGroupMembers()

local dropDown = CreateFrame("FRAME", "RaidDropDown", UIParent, "UIDropDownMenuTemplate")
dropDown:SetPoint("TOP")
UIDropDownMenu_SetWidth(dropDown, 200)
UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")

UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
    local info = UIDropDownMenu_CreateInfo()

    UIDropDownMenu_SetText(dropDown, "Raid Players (" .. raidPlayersCount .. ")")
    
    if (level or 1) == 1 then
        -- display raid players
        for i = 1, 40 do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                info.text = name
                info.menuList, info.hasArrow = i, true
                UIDropDownMenu_AddButton(info)
            end
        end
end)