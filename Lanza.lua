local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local placeId = game.PlaceId
local currentJob = game.JobId

local visited = {}
local scannedServers = 0

-- GUI BUTTON (toggle)
local gui = Instance.new("ScreenGui",game.CoreGui)

local toggle = Instance.new("TextButton",gui)
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,10,0.5,-20)
toggle.Text = "≡"
toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggle.TextColor3 = Color3.new(1,1,1)

-- MAIN GUI
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,280,0,170)
main.Position = UDim2.new(0.5,-140,0.5,-85)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
main.Visible = true

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Fast Server Hop"
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextColor3 = Color3.new(1,1,1)

local status = Instance.new("TextLabel",main)
status.Size = UDim2.new(1,0,0,40)
status.Position = UDim2.new(0,0,0,40)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.new(1,1,1)
status.Text = "Ready"

local scanInfo = Instance.new("TextLabel",main)
scanInfo.Size = UDim2.new(1,0,0,30)
scanInfo.Position = UDim2.new(0,0,0,70)
scanInfo.BackgroundTransparency = 1
scanInfo.TextColor3 = Color3.new(1,1,1)
scanInfo.Text = "Scanned : 0"

local hopBtn = Instance.new("TextButton",main)
hopBtn.Size = UDim2.new(0.8,0,0,35)
hopBtn.Position = UDim2.new(0.1,0,0.65,0)
hopBtn.Text = "Find 0 Player Server"
hopBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
hopBtn.TextColor3 = Color3.new(1,1,1)

-- toggle gui
toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- FAST SCAN
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

            if server.playing == 0
            and server.id ~= currentJob
            and not visited[server.id] then

                visited[server.id] = true
                return server

            end

        end

        cursor = data.nextPageCursor or ""

    until cursor == ""

end

-- HOP
hopBtn.MouseButton1Click:Connect(function()

    status.Text = "Scanning servers..."

    local server = findServer()

    if server then
        status.Text = "0 Player server found"
        wait(1)
        TeleportService:TeleportToPlaceInstance(placeId,server.id,player)
    else
        status.Text = "No empty server"
    end

end)
