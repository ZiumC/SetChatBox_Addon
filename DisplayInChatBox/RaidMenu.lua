local raidPlayersCount = GetNumGroupMembers()

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

-- create and configure dropdown menu
local dropDown = CreateFrame("FRAME", "RaidDropDown", UIParent, "UIDropDownMenuTemplate")
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
        for i = 1, 40 do
            local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                info.text = name
                info.menuList, info.hasArrow = i, true
                UIDropDownMenu_AddButton(info)
            end
        end

    else
        -- display a nested options of player
        info.func = self.SetValue
        for i = 1, length(BUTTONS) do
            info.text, info.icon = BUTTONS[i].title, BUTTONS[i].icon
            UIDropDownMenu_AddButton(info, level)
        end 
    end
end)