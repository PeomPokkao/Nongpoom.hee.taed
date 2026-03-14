-- SERVICES
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.Name = "PoomEditHub"

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

-- MAIN WINDOW
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

-- HOTKEY
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightControl then
		main.Visible = not main.Visible
	end
end)

-- NEON GLOW
local stroke = Instance.new("UIStroke",main)
stroke.Thickness = 2

task.spawn(function()
	while true do
		for h=0,1,0.01 do
			stroke.Color = Color3.fromHSV(h,1,1)
			task.wait(.03)
		end
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

-- LINE
local line = Instance.new("Frame",main)
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,40)
line.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- TAB BAR
local tabBar = Instance.new("Frame",main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,42)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout",tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- PAGE HOLDER
local pages = Instance.new("Frame",main)
pages.Size = UDim2.new(1,0,1,-74)
pages.Position = UDim2.new(0,0,0,74)
pages.BackgroundTransparency = 1

local pageList = {}
local tabButtons = {}

local function createTab(name,last)

	local tab = Instance.new("TextButton",tabBar)
	tab.Size = UDim2.new(0,80,1,0)
	tab.BackgroundTransparency = 1
	tab.Text = name
	tab.Font = Enum.Font.GothamBold
	tab.TextColor3 = Color3.fromRGB(170,170,170)

	local highlight = Instance.new("Frame",tab)
	highlight.Size = UDim2.new(1,0,0,2)
	highlight.Position = UDim2.new(0,0,1,-2)
	highlight.BackgroundColor3 = Color3.fromRGB(0,170,255)
	highlight.Visible = false

	local page = Instance.new("Frame",pages)
	page.Size = UDim2.new(1,0,1,0)
	page.Position = UDim2.new(1,0,0,0)
	page.Visible = false
	page.BackgroundTransparency = 1

	pageList[name] = page
	tabButtons[name] = {tab,highlight}

	tab.MouseButton1Click:Connect(function()

		for n,p in pairs(pageList) do
			p.Visible = false
			tabButtons[n][2].Visible = false
			tabButtons[n][1].TextColor3 = Color3.fromRGB(170,170,170)
		end

		page.Visible = true
		tabButtons[name][2].Visible = true
		tab.TextColor3 = Color3.new(1,1,1)

		page.Position = UDim2.new(1,0,0,0)

		TweenService:Create(page,
			TweenInfo.new(.25,Enum.EasingStyle.Quad),
			{Position = UDim2.new(0,0,0,0)}
		):Play()

	end)

	if not last then
		local sep = Instance.new("TextLabel",tabBar)
		sep.Size = UDim2.new(0,10,1,0)
		sep.BackgroundTransparency = 1
		sep.Text = "|"
		sep.Font = Enum.Font.GothamBold
		sep.TextColor3 = Color3.fromRGB(120,120,120)
	end

	return page
end

-- TABS
local misc = createTab("Misc")
createTab("Farm")
createTab("Travel")
createTab("Visual")
createTab("Settings",true)

misc.Visible = true
tabButtons["Misc"][2].Visible = true
tabButtons["Misc"][1].TextColor3 = Color3.new(1,1,1)

-- SPLIT
local left = Instance.new("Frame",misc)
left.Size = UDim2.new(.5,0,1,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame",misc)
right.Size = UDim2.new(.5,0,1,0)
right.Position = UDim2.new(.5,0,0,0)
right.BackgroundTransparency = 1

local divider = Instance.new("Frame",misc)
divider.Size = UDim2.new(0,2,1,0)
divider.Position = UDim2.new(.5,-1,0,0)
divider.BackgroundColor3 = Color3.fromRGB(70,70,70)

-- TOGGLE
local function createToggle(parent,text)

	local holder = Instance.new("Frame",parent)
	holder.Size = UDim2.new(0,200,0,36)
	holder.BackgroundTransparency = 1

	local label = Instance.new("TextLabel",holder)
	label.Size = UDim2.new(.7,0,1,0)
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
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local state = false

	toggle.InputBegan:Connect(function()

		state = not state

		local pos = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
		local color = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(90,90,90)

		TweenService:Create(knob,TweenInfo.new(.2),{Position=pos}):Play()
		TweenService:Create(toggle,TweenInfo.new(.2),{BackgroundColor3=color}):Play()

	end)

end

createToggle(left,"Server Hop")
createToggle(left,"Auto Rejoin")

local layoutRight = Instance.new("UIListLayout",right)
layoutRight.Padding = UDim.new(0,10)

-- DROPDOWN
local drop = Instance.new("TextButton",right)
drop.Size = UDim2.new(0,200,0,40)
drop.Text = "Select Island"
drop.Font = Enum.Font.GothamBold
drop.TextColor3 = Color3.new(1,1,1)
drop.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",drop)

local dropFrame = Instance.new("ScrollingFrame",right)
dropFrame.Size = UDim2.new(0,200,0,0)
dropFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
dropFrame.ScrollBarThickness = 5
dropFrame.Visible = false
dropFrame.ScrollBarImageColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner",dropFrame)

local layout = Instance.new("UIListLayout",dropFrame)

local islands = {
"Port Town","Hydra Island","Great Tree","Floating Turtle",
"Haunted Castle","Sea of Treats","Castle on the Sea",
"Tiki Outpost","Mirage Island","Chocolate Island",
"Ice Cream Island","Peanut Island","Candy Island",
"Cake Island","Loaf Island","Mansion","Leviathan Island"
}

for _,v in pairs(islands) do

	local b = Instance.new("TextButton",dropFrame)
	b.Size = UDim2.new(1,0,0,28)
	b.Text = v
	b.BackgroundTransparency = 1
	b.Font = Enum.Font.GothamBold
	b.TextColor3 = Color3.new(1,1,1)

	b.MouseButton1Click:Connect(function()
		drop.Text = v
	end)

end

dropFrame.CanvasSize = UDim2.new(0,0,0,#islands*30)

drop.MouseButton1Click:Connect(function()

	if dropFrame.Visible == false then

		dropFrame.Visible = true

		TweenService:Create(
			dropFrame,
			TweenInfo.new(.25),
			{Size = UDim2.new(0,200,0,150)}
		):Play()

	else

		TweenService:Create(
			dropFrame,
			TweenInfo.new(.25),
			{Size = UDim2.new(0,200,0,0)}
		):Play()

		task.wait(.25)
		dropFrame.Visible = false

	end

end)

createToggle(right,"Start To Island")
