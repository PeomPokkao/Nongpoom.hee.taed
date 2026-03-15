-- SERVICES
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local PlaceID = game.PlaceId

-- GUI
local ScreenGui = Instance.new("ScreenGui",game.CoreGui)

-- THEME
local Theme = {
	Main = Color3.fromRGB(25,25,25),
	Button = Color3.fromRGB(35,35,35),
	Accent = Color3.fromRGB(0,170,255),
	Text = Color3.fromRGB(255,255,255)
}

-- FLOAT ICON
local Float = Instance.new("ImageButton",ScreenGui)
Float.Size = UDim2.new(0,38,0,38)
Float.Position = UDim2.new(0,20,0.5,-19)
Float.BackgroundColor3 = Theme.Button
Float.Image = "rbxassetid://7733960981"
Instance.new("UICorner",Float).CornerRadius = UDim.new(1,0)

-- MAIN
local Main = Instance.new("Frame",ScreenGui)
Main.Size = UDim2.new(0,270,0,140)
Main.Position = UDim2.new(0.5,-135,0.5,-70)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = 0.15
Main.Visible = false
Instance.new("UICorner",Main)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Color = Theme.Accent

Float.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

-- CONTENT
local Content = Instance.new("Frame",Main)
Content.Size = UDim2.new(1,0,1,0)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout",Content)
Layout.Padding = UDim.new(0,6)

-- BUTTON
function Button(text,callback)

	local Btn = Instance.new("TextButton",Content)
	Btn.Size = UDim2.new(1,-16,0,28)
	Btn.Position = UDim2.new(0,8,0,0)
	Btn.Text = text
	Btn.BackgroundColor3 = Theme.Button
	Btn.TextColor3 = Theme.Text
	Instance.new("UICorner",Btn)

	Btn.MouseButton1Click:Connect(callback)

end

-- TOGGLE
function Toggle(text,callback)

	local T = Instance.new("TextButton",Content)
	T.Size = UDim2.new(1,-16,0,28)
	T.Text = text.." : OFF"
	T.BackgroundColor3 = Theme.Button
	T.TextColor3 = Theme.Text
	Instance.new("UICorner",T)

	local state = false

	T.MouseButton1Click:Connect(function()

		state = not state
		T.Text = text.." : "..(state and "ON" or "OFF")

		callback(state)

	end)

end

-- NOTIFICATION HOLDER
local Holder = Instance.new("Frame",ScreenGui)
Holder.Position = UDim2.new(1,-260,0,80)
Holder.Size = UDim2.new(0,240,0,200)
Holder.BackgroundTransparency = 1

local Layout2 = Instance.new("UIListLayout",Holder)
Layout2.Padding = UDim.new(0,6)

-- CREATE NOTIFICATION
local function CreateNoti()

	local Noti = Instance.new("Frame",Holder)
	Noti.Size = UDim2.new(1,0,0,45)
	Noti.BackgroundColor3 = Theme.Button
	Instance.new("UICorner",Noti)

	local Label = Instance.new("TextLabel",Noti)
	Label.Size = UDim2.new(1,-10,1,0)
	Label.Position = UDim2.new(0,5,0,0)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Theme.Text
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Enum.TextYAlignment.Top
	Label.TextWrapped = true
	Label.Text = "" -- à¹à¸à¹à¸à¸±à¸à¸«à¸² Label à¹à¸à¸¥à¹

	return Label

end

-- CREATE 3 BOX
local ServerNoti = CreateNoti()
local PlayerNoti = CreateNoti()
local MoveNoti = CreateNoti()

-- SERVER HOP
function Hop()

	local req = game:HttpGet(
		"https://games.roblox.com/v1/games/"..
		PlaceID..
		"/servers/Public?sortOrder=Asc&limit=100"
	)

	local data = HttpService:JSONDecode(req)

	local serverCount = 0

	for _,v in pairs(data.data) do

		serverCount += 1

		if v.playing < v.maxPlayers then

			ServerNoti.Text = "à¸à¸³à¸à¸§à¸à¹à¸à¸´à¸à¸à¸µà¹à¸«à¸² : "..serverCount.." à¹à¸à¸´à¸"

			local ping = v.ping or "?"

			PlayerNoti.Text =
				"à¸à¸¹à¹à¹à¸¥à¹à¸à¹à¸à¹à¸à¸´à¸ : "..v.playing.." à¸à¸\n"..
				"à¸à¸´à¸ : "..ping.." ms"

			for i=5,1,-1 do
				MoveNoti.Text = "à¸à¸³à¸¥à¸±à¸à¸¢à¹à¸²à¸¢ à¹à¸à¸­à¸µà¸ "..i.." à¸§à¸´à¸à¸²à¸à¸µ"
				task.wait(1)
			end

			TeleportService:TeleportToPlaceInstance(
				PlaceID,
				v.id,
				Players.LocalPlayer
			)

			break

		end

	end

end

-- BUTTON
Button("Hop Server",function()
	Hop()
end)

-- TOGGLE
Toggle("Hop low player",function(state)

	if state then

		task.spawn(function()

			while state do
				Hop()
				task.wait(20)
			end

		end)

	end

end)
