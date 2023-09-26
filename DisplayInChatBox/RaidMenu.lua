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

-- create and configure dropdown menu
local dropDown = CreateFrame("FRAME", "RaidDropDown", UIParent, "UIDropDownMenuTemplate")
dropDown:EnableMouse(true)
dropDown:SetMovable(true)
dropDown:RegisterForDrag("LeftButton")
dropDown:SetScript("OnDragStart", dropDown.StartMoving)
dropDown:SetScript("OnDragStop", dropDown.StopMovingOrSizing)
dropDown:SetScript("OnHide", dropDown.StopMovingOrSizing)
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
        for i = 1, maxRaidPlayers do
            local name, rank, subgroup, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
            if name ~= nil then
                info.text = name
                info.func = self.ShowOptionWindow
                info.arg1 = name
                UIDropDownMenu_AddButton(info)
            end
        end
    end
end)

function dropDown:ShowOptionWindow(playerName)
    UIDropDownMenu_SetText(dropDown, "Selected player: " .. playerName)
    CloseDropDownMenus()

    local window = CreateFrame("FRAME", "PlayerOptionsFrame", UIParent)
    window:SetSize(350, 100)
    window:SetPoint("CENTER")

    window:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeSize = 1,
    })
    window:SetBackdropColor(0, 0, 0, .5)
    window:SetBackdropBorderColor(0, 0, 0)
    window:EnableMouse(true)
    window:SetMovable(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)
    window:SetScript("OnHide", window.StopMovingOrSizing)

    local close = CreateFrame("BUTTON", "CloseBtn", window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT")
    close:SetScript("OnClick", function()
        window:Hide()
    end)

    local appendBtn = CreateFrame("BUTTON", "AppendBtn", window, "UIPanelButtonTemplate")
	appendBtn:SetPoint("TOP", window, "CENTER", 0, 35)
	appendBtn:SetWidth(75)
	appendBtn:SetHeight(25)
    appendBtn:SetText("Append")
    appendBtn:SetScript("OnClick", function()
        print("a1")
        window:Hide()
    end)
	
    local checkBtn = CreateFrame("BUTTON", "CheckBtn", window, "UIPanelButtonTemplate")
	checkBtn:SetPoint("TOP", window, "CENTER", 0, 0)
	checkBtn:SetWidth(75)
	checkBtn:SetHeight(25)
    checkBtn:SetText("!check")
    checkBtn:SetScript("OnClick", function()
        print("a2")
        window:Hide()
    end)

    local nameBtn = CreateFrame("BUTTON", "CheckBtn", window, "UIPanelButtonTemplate")
	nameBtn:SetPoint("TOP", window, "CENTER", 0,-35)
	nameBtn:SetWidth(75)
	nameBtn:SetHeight(25)
    nameBtn:SetText("Name")
    nameBtn:SetScript("OnClick", function()
        print("a3")
        window:Hide()
    end)

end