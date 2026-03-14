--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--// STATE
local currentTween
local rainbowPart
local selectedIsland = nil

--// ISLAND POSITIONS (Sea 3 example)
local Islands = {
["Port Town"] = Vector3.new(-290,5,5343),
["Hydra Island"] = Vector3.new(5220,604,345),
["Great Tree"] = Vector3.new(2276,25,-6500),
["Floating Turtle"] = Vector3.new(-13200,350,-7900),
["Castle on the Sea"] = Vector3.new(-5100,314,-3150),
["Haunted Castle"] = Vector3.new(-9515,142,5537),
["Sea of Treats"] = Vector3.new(-2000,50,-12000),
["Tiki Outpost"] = Vector3.new(-16200,20,-100)
}

--// TWEEN
local function TweenTo(pos)

local dist = (hrp.Position-pos).Magnitude
local speed = 250
local t = dist/speed

currentTween = TweenService:Create(
hrp,
TweenInfo.new(t,Enum.EasingStyle.Linear),
{CFrame = CFrame.new(pos)}
)

currentTween:Play()

end

--// RAINBOW FLOOR
local function createRainbow()

rainbowPart = Instance.new("Part")
rainbowPart.Size = Vector3.new(8,1,8)
rainbowPart.Anchored = true
rainbowPart.CanCollide = false
rainbowPart.Material = Enum.Material.Neon
rainbowPart.Parent = workspace

task.spawn(function()

local hue = 0

while rainbowPart do

hue = (hue + .01) % 1
rainbowPart.Color = Color3.fromHSV(hue,1,1)
rainbowPart.CFrame = hrp.CFrame * CFrame.new(0,-3,0)

task.wait()

end

end)

end

local function removeRainbow()

if rainbowPart then
rainbowPart:Destroy()
rainbowPart=nil
end

end

--// SERVER HOP
local function serverHop()

local placeId = game.PlaceId
local cursor = ""

repeat

local url =
"https://games.roblox.com/v1/games/"..
placeId..
"/servers/Public?sortOrder=Asc&limit=100&cursor="..
cursor

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,server in pairs(data.data) do

if server.playing <= 8 then
TeleportService:TeleportToPlaceInstance(placeId,server.id,player)
return
end

end

cursor = data.nextPageCursor or ""

until cursor == ""

end

--// UI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PoomEdit"

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,340)
main.Position = UDim2.new(.5,-260,.5,-170)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Poom Edit"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)

-- TAB BAR
local tabBar = Instance.new("Frame",main)
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",tabBar)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0,10)

-- PAGES
local pages = Instance.new("Frame",main)
pages.Size = UDim2.new(1,0,1,-75)
pages.Position = UDim2.new(0,0,0,75)
pages.BackgroundTransparency = 1

local function createTab(name)

local tab = Instance.new("TextButton",tabBar)
tab.Size = UDim2.new(0,90,1,0)
tab.Text = name
tab.Font = Enum.Font.GothamBold
tab.TextColor3 = Color3.new(1,1,1)
tab.BackgroundColor3 = Color3.fromRGB(35,35,35)

Instance.new("UICorner",tab)

local page = Instance.new("Frame",pages)
page.Size = UDim2.new(1,0,1,0)
page.BackgroundTransparency = 1
page.Visible = false

tab.MouseButton1Click:Connect(function()

for _,v in pairs(pages:GetChildren()) do
if v:IsA("Frame") then
v.Visible = false
end
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

-- MISC PAGE LAYOUT
local left = Instance.new("Frame",miscPage)
left.Size = UDim2.new(.5,-5,1,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame",miscPage)
right.Size = UDim2.new(.5,-5,1,0)
right.Position = UDim2.new(.5,5,0,0)
right.BackgroundTransparency = 1

-- SERVER HOP BUTTON
local hopBtn = Instance.new("TextButton",left)
hopBtn.Size = UDim2.new(0,180,0,40)
hopBtn.Position = UDim2.new(0,20,0,40)
hopBtn.Text = "Server Hop"
hopBtn.Font = Enum.Font.GothamBold
hopBtn.TextColor3 = Color3.new(1,1,1)
hopBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)

Instance.new("UICorner",hopBtn)

hopBtn.MouseButton1Click:Connect(function()
serverHop()
end)

-- DROPDOWN
local dropdown = Instance.new("TextButton",right)
dropdown.Size = UDim2.new(0,200,0,40)
dropdown.Position = UDim2.new(0,20,0,40)
dropdown.Text = "Select Island"
dropdown.Font = Enum.Font.GothamBold
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.BackgroundColor3 = Color3.fromRGB(45,45,45)

Instance.new("UICorner",dropdown)

dropdown.MouseButton1Click:Connect(function()

for name,_ in pairs(Islands) do
selectedIsland = name
dropdown.Text = name
break
end

end)

-- START TO ISLAND
local startBtn = Instance.new("TextButton",right)
startBtn.Size = UDim2.new(0,200,0,40)
startBtn.Position = UDim2.new(0,20,0,100)
startBtn.Text = "Start To Island : OFF"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)

Instance.new("UICorner",startBtn)

local moving = false

startBtn.MouseButton1Click:Connect(function()

if moving then

moving = false
startBtn.Text = "Start To Island : OFF"
startBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)

if currentTween then
currentTween:Cancel()
end

removeRainbow()

else

if selectedIsland then

moving = true
startBtn.Text = "Start To Island : ON"
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

createRainbow()
TweenTo(Islands[selectedIsland])

end

end

end)
