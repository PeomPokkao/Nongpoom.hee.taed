local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId
local currentJob = game.JobId

local visited = {}
local scannedServers = 0
local autoHop = false
local playerLimit = 8

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,300,0,220)
main.Position = UDim2.new(0.5,-150,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner",main)
corner.CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Server Hop"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- scan counter
local scanInfo = Instance.new("TextLabel",main)
scanInfo.Position = UDim2.new(0,0,0,40)
scanInfo.Size = UDim2.new(1,0,0,25)
scanInfo.BackgroundTransparency = 1
scanInfo.TextColor3 = Color3.new(1,1,1)
scanInfo.Text = "Scanned : 0"

-- toggle
local toggle = Instance.new("TextButton",main)
toggle.Position = UDim2.new(0.1,0,0.7,0)
toggle.Size = UDim2.new(0.8,0,0,35)
toggle.Text = "Auto Hop : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200,60,60)

Instance.new("UICorner",toggle)

-- dropdown
local dropdown = Instance.new("TextButton",main)
dropdown.Position = UDim2.new(0.1,0,0.4,0)
dropdown.Size = UDim2.new(0.8,0,0,30)
dropdown.Text = "Players ≤ "..playerLimit
dropdown.BackgroundColor3 = Color3.fromRGB(40,40,40)

Instance.new("UICorner",dropdown)

local dropFrame = Instance.new("Frame",main)
dropFrame.Position = UDim2.new(0.1,0,0.55,0)
dropFrame.Size = UDim2.new(0.8,0,0,120)
dropFrame.Visible = false
dropFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)

Instance.new("UICorner",dropFrame)

for i=1,12 do

local opt = Instance.new("TextButton",dropFrame)
opt.Size = UDim2.new(1,0,0,20)
opt.Position = UDim2.new(0,0,0,(i-1)*20)
opt.Text = "≤ "..i
opt.BackgroundTransparency = 1
opt.TextColor3 = Color3.new(1,1,1)

opt.MouseButton1Click:Connect(function()

playerLimit = i
dropdown.Text = "Players ≤ "..i
dropFrame.Visible = false

end)

end

dropdown.MouseButton1Click:Connect(function()
dropFrame.Visible = not dropFrame.Visible
end)

-- notification
local function notify(text)

local n = Instance.new("TextLabel",gui)
n.Size = UDim2.new(0,220,0,40)
n.Position = UDim2.new(1,-230,0,20)
n.BackgroundColor3 = Color3.fromRGB(20,20,20)
n.TextColor3 = Color3.new(1,1,1)
n.Text = text

Instance.new("UICorner",n)

task.delay(4,function()
n:Destroy()
end)

end

toggle.MouseButton1Click:Connect(function()

autoHop = not autoHop

if autoHop then
toggle.Text = "Auto Hop : ON"
toggle.BackgroundColor3 = Color3.fromRGB(60,200,100)
notify("Auto Hop Enabled")
else
toggle.Text = "Auto Hop : OFF"
toggle.BackgroundColor3 = Color3.fromRGB(200,60,60)
notify("Auto Hop Disabled")
end

end)

-- find server
local function findServer()

scannedServers = 0
local cursor = ""

repeat

local url =
"https://games.roblox.com/v1/games/"..
placeId..
"/servers/Public?sortOrder=Asc&limit=100&cursor="..
cursor

local data = HttpService:JSONDecode(game:HttpGet(url))

for _,server in pairs(data.data) do

scannedServers += 1
scanInfo.Text = "Scanned : "..scannedServers

if server.playing <= playerLimit
and server.id ~= currentJob
and not visited[server.id] then

visited[server.id] = true
return server

end

end

cursor = data.nextPageCursor or ""

until cursor == ""

end

task.spawn(function()

while true do
task.wait(1)

if autoHop then

notify("Scanning servers...")

local server = findServer()

if server then
notify("Teleporting ("..server.playing.." players)")
task.wait(1)
TeleportService:TeleportToPlaceInstance(placeId,server.id,player)
end

end

end

end)
