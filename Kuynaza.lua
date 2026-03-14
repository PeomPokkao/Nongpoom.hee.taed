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
gui.Name = "PoomEdit"

-- OPEN BUTTON
local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,35,0,35)
open.Position = UDim2.new(0,10,0.5,-20)
open.Text = "≡"
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1,1,1)
open.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",open).CornerRadius = UDim.new(1,0)

-- MAIN UI
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,320)
main.Position = UDim2.new(0.5,-260,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = true
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke",main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "Poom Edit"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

-- TAB BAR
local tabBar = Instance.new("TextLabel",main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,35)
tabBar.BackgroundTransparency = 1
tabBar.Text = "Misc | Farm | Teleport | Other"
tabBar.Font = Enum.Font.GothamBold
tabBar.TextSize = 16
tabBar.TextColor3 = Color3.new(1,1,1)

-- CONTENT AREA
local content = Instance.new("Frame",main)
content.Size = UDim2.new(1,0,1,-70)
content.Position = UDim2.new(0,0,0,70)
content.BackgroundTransparency = 1

-- LEFT SIDE
local left = Instance.new("Frame",content)
left.Size = UDim2.new(0.5,-5,1,0)
left.BackgroundTransparency = 1

-- RIGHT SIDE
local right = Instance.new("Frame",content)
right.Size = UDim2.new(0.5,-5,1,0)
right.Position = UDim2.new(0.5,5,0,0)
right.BackgroundTransparency = 1

-- SCAN TEXT
local scanText = Instance.new("TextLabel",left)
scanText.Size = UDim2.new(1,0,0,50)
scanText.BackgroundTransparency = 1
scanText.Text = "Scanned : 0"
scanText.Font = Enum.Font.GothamBold
scanText.TextSize = 28
scanText.TextColor3 = Color3.new(1,1,1)

-- TOGGLE AUTO HOP
local hopToggle = Instance.new("TextButton",left)
hopToggle.Size = UDim2.new(0,160,0,35)
hopToggle.Position = UDim2.new(0,0,0,70)
hopToggle.Text = "Auto Hop : OFF"
hopToggle.Font = Enum.Font.GothamBold
hopToggle.TextColor3 = Color3.new(1,1,1)
hopToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner",hopToggle)

-- TOGGLE AUTO REJOIN
local rejoinToggle = Instance.new("TextButton",left)
rejoinToggle.Size = UDim2.new(0,160,0,35)
rejoinToggle.Position = UDim2.new(0,0,0,120)
rejoinToggle.Text = "Auto Rejoin : OFF"
rejoinToggle.Font = Enum.Font.GothamBold
rejoinToggle.TextColor3 = Color3.new(1,1,1)
rejoinToggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
Instance.new("UICorner",rejoinToggle)

-- NOTIFICATION
local function notify(text)

    local n = Instance.new("TextLabel",gui)
    n.Size = UDim2.new(0,200,0,40)
    n.Position = UDim2.new(1,-210,0.7,0)
    n.BackgroundColor3 = Color3.fromRGB(40,40,40)
    n.TextColor3 = Color3.new(1,1,1)
    n.Text = text
    n.Font = Enum.Font.GothamBold
    n.TextSize = 16
    Instance.new("UICorner",n)

    task.delay(4,function()
        n:Destroy()
    end)

end

-- OPEN CLOSE UI
open.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    notify("UI "..(main.Visible and "Opened" or "Closed"))
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
            scanText.Text = "Scanned : "..scannedServers

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

-- AUTO HOP
hopToggle.MouseButton1Click:Connect(function()

    autoHop = not autoHop

    hopToggle.Text = "Auto Hop : "..(autoHop and "ON" or "OFF")
    hopToggle.BackgroundColor3 = autoHop and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)

    notify("Auto Hop "..(autoHop and "Enabled" or "Disabled"))

    while autoHop do

        local server = findServer()

        if server then
            TeleportService:TeleportToPlaceInstance(placeId,server.id,player)
        end

        task.wait(3)

    end

end)

-- AUTO REJOIN
rejoinToggle.MouseButton1Click:Connect(function()

    autoRejoin = not autoRejoin

    rejoinToggle.Text = "Auto Rejoin : "..(autoRejoin and "ON" or "OFF")
    rejoinToggle.BackgroundColor3 = autoRejoin and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)

    notify("Auto Rejoin "..(autoRejoin and "Enabled" or "Disabled"))

end)
