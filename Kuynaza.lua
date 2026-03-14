-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PoomEditHub"

-- OPEN BUTTON
local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,40,0,40)
open.Position = UDim2.new(0,10,0.5,-20)
open.Text = "≡"
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1,1,1)
open.TextSize = 22
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

open.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- TITLE
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Poom Edit"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)

-- LINE
local line = Instance.new("Frame",main)
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,40)
line.BackgroundColor3 = Color3.fromRGB(80,80,80)

-- TAB BAR
local tabBar = Instance.new("Frame",main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,42)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout",tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0,12)

-- PAGE HOLDER
local pages = Instance.new("Frame",main)
pages.Size = UDim2.new(1,0,1,-74)
pages.Position = UDim2.new(0,0,0,74)
pages.BackgroundTransparency = 1

local pageList = {}

-- TAB FUNCTION
local function createTab(name)

	local tab = Instance.new("TextButton",tabBar)
	tab.Size = UDim2.new(0,80,1,0)
	tab.BackgroundTransparency = 1
	tab.Text = name
	tab.Font = Enum.Font.GothamBold
	tab.TextColor3 = Color3.new(1,1,1)

	local page = Instance.new("Frame",pages)
	page.Size = UDim2.new(1,0,1,0)
	page.Position = UDim2.new(1,0,0,0)
	page.Visible = false
	page.BackgroundTransparency = 1

	pageList[name] = page

	tab.MouseButton1Click:Connect(function()

		for _,p in pairs(pageList) do
			p.Visible = false
		end

		page.Visible = true
		page.Position = UDim2.new(1,0,0,0)

		TweenService:Create(
			page,
			TweenInfo.new(.25,Enum.EasingStyle.Quad),
			{Position = UDim2.new(0,0,0,0)}
		):Play()

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
local left = Instance.new("Frame",miscPage)
left.Size = UDim2.new(.5,0,1,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame",miscPage)
right.Size = UDim2.new(.5,0,1,0)
right.Position = UDim2.new(.5,0,0,0)
right.BackgroundTransparency = 1

local divider = Instance.new("Frame",miscPage)
divider.Size = UDim2.new(0,2,1,0)
divider.Position = UDim2.new(.5,-1,0,0)
divider.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- TOGGLE FUNCTION
local function createToggle(parent,text,pos)

	local holder = Instance.new("Frame",parent)
	holder.Size = UDim2.new(0,200,0,36)
	holder.Position = pos
	holder.BackgroundTransparency = 1

	local label = Instance.new("TextLabel",holder)
	label.Size = UDim2.new(0.7,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = Instance.new("Frame",holder)
	toggle.Size = UDim2.new(0,40,0,20)
	toggle.Position = UDim2.new(1,-40,0.5,-10)
	toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
	Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame",toggle)
	knob.Size = UDim2.new(0,18,0,18)
	knob.Position = UDim2.new(0,1,0.5,-9)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local state = false

	toggle.InputBegan:Connect(function()

		state = not state

		local goal = state and UDim2.new(1,-19,0.5,-9) or UDim2.new(0,1,0.5,-9)
		local color = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(80,80,80)

		TweenService:Create(knob,TweenInfo.new(.2),{Position = goal}):Play()
		TweenService:Create(toggle,TweenInfo.new(.2),{BackgroundColor3 = color}):Play()

	end)

end

-- LEFT SIDE
createToggle(left,"Server Hop",UDim2.new(0,20,0,30))
createToggle(left,"Auto Rejoin",UDim2.new(0,20,0,80))

local scan = Instance.new("TextLabel",left)
scan.Size = UDim2.new(0,200,0,40)
scan.Position = UDim2.new(0,20,0,140)
scan.Text = "Server Scan : 0"
scan.Font = Enum.Font.GothamBold
scan.TextSize = 18
scan.TextColor3 = Color3.new(1,1,1)
scan.BackgroundTransparency = 1

-- ISLAND LIST
local islands = {

"Port Town",
"Hydra Island",
"Great Tree",
"Floating Turtle",
"Haunted Castle",
"Sea of Treats",
"Castle on the Sea",
"Tiki Outpost",
"Mirage Island",
"Chocolate Island",
"Ice Cream Island",
"Peanut Island",
"Candy Island",
"Cake Island",
"Loaf Island",
"Mansion",
"Leviathan Island"

}

-- DROPDOWN BUTTON
local drop = Instance.new("TextButton",right)
drop.Size = UDim2.new(0,200,0,40)
drop.Position = UDim2.new(0,20,0,30)
drop.Text = "Select Island"
drop.Font = Enum.Font.GothamBold
drop.TextColor3 = Color3.new(1,1,1)
drop.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",drop)

-- SCROLL DROPDOWN
local dropFrame = Instance.new("ScrollingFrame",right)
dropFrame.Size = UDim2.new(0,200,0,150)
dropFrame.Position = UDim2.new(0,20,0,75)
dropFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
dropFrame.ScrollBarThickness = 4
dropFrame.Visible = false
Instance.new("UICorner",dropFrame)

local layout = Instance.new("UIListLayout",dropFrame)
layout.Padding = UDim.new(0,2)

for _,name in pairs(islands) do

	local option = Instance.new("TextButton",dropFrame)
	option.Size = UDim2.new(1,0,0,28)
	option.Text = name
	option.Font = Enum.Font.GothamBold
	option.TextColor3 = Color3.new(1,1,1)
	option.BackgroundTransparency = 1

	option.MouseButton1Click:Connect(function()
		drop.Text = name
		dropFrame.Visible = false
	end)

end

dropFrame.CanvasSize = UDim2.new(0,0,0,#islands*30)

drop.MouseButton1Click:Connect(function()
	dropFrame.Visible = not dropFrame.Visible
end)

-- START TO ISLAND
createToggle(right,"Start To Island",UDim2.new(0,20,0,240))
