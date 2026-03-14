local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
Name = "Poom Edit",
HidePremium = false,
SaveConfig = false,
IntroEnabled = false
})

-- TAB
local FarmTab = Window:MakeTab({
Name = "Farm",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local TeleportTab = Window:MakeTab({
Name = "Teleport",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

local MiscTab = Window:MakeTab({
Name = "Misc",
Icon = "rbxassetid://4483345998",
PremiumOnly = false
})

-- FARM
FarmTab:AddToggle({
Name = "Auto Farm",
Default = false,
Callback = function(Value)
print("Auto Farm:",Value)
end
})

FarmTab:AddButton({
Name = "Server Hop",
Callback = function()
print("Server Hop")
end
})

-- TELEPORT
TeleportTab:AddDropdown({
Name = "Select Island",
Default = "",
Options = {
"Port Town",
"Hydra Island",
"Great Tree",
"Floating Turtle",
"Haunted Castle"
},
Callback = function(Value)
print(Value)
end
})

TeleportTab:AddButton({
Name = "Teleport",
Callback = function()
print("Teleport")
end
})

-- MISC
MiscTab:AddToggle({
Name = "Auto Rejoin",
Default = false,
Callback = function(Value)
print("Auto Rejoin:",Value)
end
})

MiscTab:AddTextbox({
Name = "Input",
Default = "",
TextDisappear = false,
Callback = function(Value)
print(Value)
end
})

MiscTab:AddBind({
Name = "Toggle UI",
Default = Enum.KeyCode.RightControl,
Hold = false,
Callback = function()
OrionLib:Toggle()
end
})

OrionLib:Init()
