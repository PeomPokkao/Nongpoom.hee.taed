local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId
local currentJob = game.JobId

local visited = {}
local scannedServers = 0
local autoHop = false
local autoRejoin = false

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)

-- OPEN UI BUTTON
local openBtn = Instance.new("TextButton",gui)
openBtn.Size = UDim2.new(0,40,0,40)
openBtn.Position = UDim2.new(0,10,0.5,-20)
openBtn.Text = "≡"
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 18
Instance.new("UICorner",openBtn)

-- MAIN
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,300,0,220)
main.Position = UDim2.new(0.5,-150,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Server Hop"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- SCAN INFO
local scanInfo = Instance.new("TextLabel",main)
scanInfo.Position = UDim2.new(0,0,0,40)
scanInfo.Size = UDim2.new(1,0,0,25)
scanInfo.BackgroundTransparency = 1
scanInfo.TextColor3 = Color3.new(1,1,1)
scanInfo.Font = Enum.Font.GothamBold
scanInfo.Text = "Scanned : 0"

-- AUTO HOP TOGGLE
local toggleHop = Instance.new("TextButton",main)
toggleHop.Position = UDim2.new(0.1,0,0.55,0)
toggleHop.Size = UDim2.new(0.8,0,0,35)
toggleHop.Text = "Auto Hop : OFF"
toggleHop.BackgroundColor3 = Color3.fromRGB(200,60,60)
toggleHop.TextColor3 = Color3.new(1,1,1)
toggleHop.Font = Enum.Font.GothamBold
Instance.new("UICorner",toggleHop)

-- REJOIN TOGGLE
local toggleRejoin = Instance.new("TextButton",main)
toggleRejoin.Position = UDim2.new(0.1,0,0.75,0)
toggleRejoin.Size = UDim2.new(0.8,0,0,35)
toggleRejoin.Text = "Auto Rejoin : OFF"
toggleRejoin.BackgroundColor3 = Color3.fromRGB(200,60,60)
toggleRejoin.TextColor3 = Color3.new(1,1,1)
toggleRejoin.Font = Enum.Font.GothamBold
Instance.new("UICorner",toggleRejoin)

-- NOTIFICATION
local function notify(text)

local n = Instance.new("TextLabel",gui)
n.Size = UDim2.new(0,220,0,40)
n.Position = UDim2.new(1,-230,0,20)
n.BackgroundColor3 = Color3.fromRGB(20,20,20)
n.TextColor3 = Color3.new(1,1,1)
n.Font = Enum.Font.GothamBold
n.Text = text

Instance.new("UICorner",n)

task.delay(4,function()
n:Destroy()
end)

end

-- TOGGLE HOP
toggleHop.MouseButton1Click:Connect(function()

autoHop = not autoHop

if autoHop then
toggleHop.Text = "Auto Hop : ON"
toggleHop.BackgroundColor3 = Color3.fromRGB(60,200,100)
notify("Auto Hop Enabled")
else
toggleHop.Text = "Auto Hop : OFF"
toggleHop.BackgroundColor3 = Color3.fromRGB(200,60,60)
notify("Auto Hop Disabled")
end

end)

-- TOGGLE REJOIN
toggleRejoin.MouseButton1Click:Connect(function()

autoRejoin = not autoRejoin

if autoRejoin then
toggleRejoin.Text = "Auto Rejoin : ON"
toggleRejoin.BackgroundColor3 = Color3.fromRGB(60,200,100)
notify("Auto Rejoin Enabled")
else
toggleRejoin.Text = "Auto Rejoin : OFF"
toggleRejoin.BackgroundColor3 = Color3.fromRGB(200,60,60)
notify("Auto Rejoin Disabled")
end

end)

-- OPEN / CLOSE UI
openBtn.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
end)

-- FIND SERVER
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

if server.playing <= 8
and server.id ~= currentJob
and not visited[server.id] then

visited[server.id] = true
return server

end

end

cursor = data.nextPageCursor or ""

until cursor == ""

end

-- AUTO HOP LOOP
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

-- AUTO REJOIN
Players.LocalPlayer.OnTeleport:Connect(function(state)

if autoRejoin and state == Enum.TeleportState.Failed then
notify("Teleport Failed - Rejoining")
task.wait(2)
TeleportService:Teleport(placeId,player)
end

end)
