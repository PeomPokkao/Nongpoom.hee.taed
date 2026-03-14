-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PoomEdit"

-- MAIN
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,340)
main.Position = UDim2.new(.5,-260,.5,-170)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Poom Edit"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)

-- LINE
local line1 = Instance.new("Frame",main)
line1.Size = UDim2.new(1,0,0,2)
line1.Position = UDim2.new(0,0,0,40)
line1.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- TAB BAR
local tabBar = Instance.new("Frame",main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,42)
tabBar.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",tabBar)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0,12)

-- PAGES HOLDER
local pages = Instance.new("Frame",main)
pages.Size = UDim2.new(1,0,1,-74)
pages.Position = UDim2.new(0,0,0,74)
pages.BackgroundTransparency = 1

-- CENTER LINE
local function makeSplit(page)

local left = Instance.new("Frame",page)
left.Size = UDim2.new(.5,0,1,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame",page)
right.Size = UDim2.new(.5,0,1,0)
right.Position = UDim2.new(.5,0,0,0)
right.BackgroundTransparency = 1

local line = Instance.new("Frame",page)
line.Size = UDim2.new(0,2,1,0)
line.Position = UDim2.new(.5,-1,0,0)
line.BackgroundColor3 = Color3.fromRGB(70,70,70)

return left,right

end

-- TAB SYSTEM
local pagesTable = {}

local function createTab(name)

local tab = Instance.new("TextButton",tabBar)
tab.Text = name
tab.Size = UDim2.new(0,80,1,0)
tab.BackgroundTransparency = 1
tab.TextColor3 = Color3.new(1,1,1)
tab.Font = Enum.Font.GothamBold

local page = Instance.new("Frame",pages)
page.Size = UDim2.new(1,0,1,0)
page.BackgroundTransparency = 1
page.Visible = false

pagesTable[name] = page

tab.MouseButton1Click:Connect(function()

for _,p in pairs(pagesTable) do
p.Visible = false
end

page.Visible = true

end)

return page

end

-- CREATE TABS
local miscPage = createTab("Misc")
local farmPage = createTab("Farm")
local travelPage = createTab("Travel")
local visualPage = createTab("Visual")
local settingsPage = createTab("Settings")

miscPage.Visible = true

-- SPLIT PANELS
local left,right = makeSplit(miscPage)

-- SERVER HOP
local hopToggle = Instance.new("TextButton",left)
hopToggle.Size = UDim2.new(0,180,0,40)
hopToggle.Position = UDim2.new(0,20,0,30)
hopToggle.Text = "Server Hop : OFF"
hopToggle.Font = Enum.Font.GothamBold
hopToggle.TextColor3 = Color3.new(1,1,1)
hopToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner",hopToggle)

local hop = false

hopToggle.MouseButton1Click:Connect(function()

hop = not hop

if hop then
hopToggle.Text = "Server Hop : ON"
hopToggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
else
hopToggle.Text = "Server Hop : OFF"
hopToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
end

end)

-- AUTO REJOIN
local rejoinToggle = Instance.new("TextButton",left)
rejoinToggle.Size = UDim2.new(0,180,0,40)
rejoinToggle.Position = UDim2.new(0,20,0,90)
rejoinToggle.Text = "Auto Rejoin : OFF"
rejoinToggle.Font = Enum.Font.GothamBold
rejoinToggle.TextColor3 = Color3.new(1,1,1)
rejoinToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner",rejoinToggle)

-- SERVER SCAN
local scanLabel = Instance.new("TextLabel",left)
scanLabel.Size = UDim2.new(0,200,0,40)
scanLabel.Position = UDim2.new(0,20,0,150)
scanLabel.BackgroundTransparency = 1
scanLabel.Text = "Server Scan : 0"
scanLabel.Font = Enum.Font.GothamBold
scanLabel.TextColor3 = Color3.new(1,1,1)
scanLabel.TextSize = 18

-- ISLAND DROPDOWN
local islandDrop = Instance.new("TextButton",right)
islandDrop.Size = UDim2.new(0,200,0,40)
islandDrop.Position = UDim2.new(0,20,0,30)
islandDrop.Text = "Select Island"
islandDrop.Font = Enum.Font.GothamBold
islandDrop.TextColor3 = Color3.new(1,1,1)
islandDrop.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",islandDrop)

-- START TO ISLAND
local startIsland = Instance.new("TextButton",right)
startIsland.Size = UDim2.new(0,200,0,40)
startIsland.Position = UDim2.new(0,20,0,90)
startIsland.Text = "Start To Island : OFF"
startIsland.Font = Enum.Font.GothamBold
startIsland.TextColor3 = Color3.new(1,1,1)
startIsland.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner",startIsland)
