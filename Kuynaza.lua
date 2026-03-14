-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "PoomEdit"

-- OPEN BUTTON
local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,40,0,40)
open.Position = UDim2.new(0,10,0.5,-20)
open.Text = "≡"
open.Font = Enum.Font.GothamBold
open.TextSize = 22
open.TextColor3 = Color3.new(1,1,1)
open.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner",open)

-- MAIN
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,340)
main.Position = UDim2.new(.5,-260,.5,-170)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

-- UI GLOW
local glow = Instance.new("UIStroke",main)
glow.Thickness = 2

task.spawn(function()
	while true do
		for h=0,1,0.01 do
			glow.Color = Color3.fromHSV(h,1,1)
			task.wait(.03)
		end
	end
end)

open.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- HOTKEY
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightControl then
		main.Visible = not main.Visible
	end
end)

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Poom Edit"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)

-- NOTIFICATION
local function notify(text)

	local n = Instance.new("TextLabel",gui)
	n.Size = UDim2.new(0,260,0,40)
	n.Position = UDim2.new(1,-270,1,-80)
	n.BackgroundColor3 = Color3.fromRGB(35,35,35)
	n.Text = text
	n.TextColor3 = Color3.new(1,1,1)
	n.Font = Enum.Font.GothamBold
	n.TextSize = 16
	Instance.new("UICorner",n)

	TweenService:Create(n,TweenInfo.new(.3),
	{Position = UDim2.new(1,-270,1,-130)}):Play()

	task.wait(4)

	TweenService:Create(n,TweenInfo.new(.3),
	{Position = UDim2.new(1,-270,1,-80)}):Play()

	task.wait(.3)
	n:Destroy()

end

-- SPLIT
local misc = Instance.new("Frame",main)
misc.Size = UDim2.new(1,0,1,-50)
misc.Position = UDim2.new(0,0,0,50)
misc.BackgroundTransparency = 1

local left = Instance.new("Frame",misc)
left.Size = UDim2.new(.5,0,1,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame",misc)
right.Size = UDim2.new(.5,0,1,0)
right.Position = UDim2.new(.5,0,0,0)
right.BackgroundTransparency = 1

local leftLayout = Instance.new("UIListLayout",left)
leftLayout.Padding = UDim.new(0,14)

local rightLayout = Instance.new("UIListLayout",right)
rightLayout.Padding = UDim.new(0,14)

-- SERVER HOP BUTTON
local hop = Instance.new("TextButton",left)
hop.Size = UDim2.new(0,220,0,40)
hop.Text = "Server Hop"
hop.Font = Enum.Font.GothamBold
hop.TextColor3 = Color3.new(1,1,1)
hop.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",hop)

hop.MouseButton1Click:Connect(function()

	notify("กำลังย้ายเซิร์ฟ...")

	local place = game.PlaceId
	local servers = {}

	local req = game:HttpGet(
	"https://games.roblox.com/v1/games/"..
	place.."/servers/Public?sortOrder=Asc&limit=100"
	)

	local data = HttpService:JSONDecode(req)

	for _,v in pairs(data.data) do
		if v.playing < v.maxPlayers then
			table.insert(servers,v.id)
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(
		place,
		servers[math.random(1,#servers)],
		player)
	end

end)

-- TOGGLE
local autoRejoin = false

local function createToggle(parent,text,callback)

	local state = false

	local holder = Instance.new("Frame",parent)
	holder.Size = UDim2.new(0,220,0,40)
	holder.BackgroundTransparency = 1

	local label = Instance.new("TextLabel",holder)
	label.Size = UDim2.new(.7,0,1,0)
	label.Position = UDim2.new(0,8,0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = Instance.new("Frame",holder)
	toggle.Size = UDim2.new(0,42,0,22)
	toggle.Position = UDim2.new(1,-42,0.5,-11)
	toggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame",toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,2,0.5,-9)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",knob)

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then

			state = not state

			if state then

				TweenService:Create(knob,TweenInfo.new(.2),
				{Position = UDim2.new(1,-20,0.5,-9)}):Play()

				TweenService:Create(toggle,TweenInfo.new(.2),
				{BackgroundColor3 = Color3.fromRGB(0,170,255)}):Play()

				notify(text.." ON")

			else

				TweenService:Create(knob,TweenInfo.new(.2),
				{Position = UDim2.new(0,2,0.5,-9)}):Play()

				TweenService:Create(toggle,TweenInfo.new(.2),
				{BackgroundColor3 = Color3.fromRGB(90,90,90)}):Play()

				notify(text.." OFF")

			end

			callback(state)

		end
	end)

end

-- AUTO REJOIN
createToggle(left,"Auto Rejoin",function(v)
	autoRejoin = v
end)

player.OnTeleport:Connect(function(state)

	if autoRejoin and state == Enum.TeleportState.Failed then

		task.wait(2)

		TeleportService:Teleport(
		game.PlaceId,
		player)

	end

end)
