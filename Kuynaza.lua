-- POOM UI LIBRARY V5
-- single script hub style

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {}

function Library:CreateWindow(title)

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "PoomUILibrary"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

--------------------------------------------------
-- MAIN WINDOW
--------------------------------------------------

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,900,0,500)
main.Position = UDim2.new(0.5,-450,0.5,-250)
main.BackgroundColor3 = Color3.fromRGB(24,24,24)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

--------------------------------------------------
-- NEON BORDER
--------------------------------------------------

local stroke = Instance.new("UIStroke",main)
stroke.Thickness = 2

local grad = Instance.new("UIGradient",stroke)
grad.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromRGB(0,170,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255))
}

task.spawn(function()
while true do
TweenService:Create(grad,TweenInfo.new(4),{
Rotation = grad.Rotation + 180
}):Play()
task.wait(4)
end
end)

--------------------------------------------------
-- TOPBAR
--------------------------------------------------

local top = Instance.new("Frame",main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(18,18,18)

local titleLabel = Instance.new("TextLabel",top)
titleLabel.Size = UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = title
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- HOTKEY
--------------------------------------------------

UIS.InputBegan:Connect(function(input)
if input.KeyCode == Enum.KeyCode.RightShift then
main.Visible = not main.Visible
end
end)

--------------------------------------------------
-- SIDEBAR
--------------------------------------------------

local sidebar = Instance.new("Frame",main)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.Size = UDim2.new(0,200,1,-40)
sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)

local divider = Instance.new("Frame",main)
divider.Position = UDim2.new(0,200,0,40)
divider.Size = UDim2.new(0,1,1,-40)
divider.BackgroundColor3 = Color3.fromRGB(60,60,60)

--------------------------------------------------
-- CONTENT
--------------------------------------------------

local content = Instance.new("Frame",main)
content.Position = UDim2.new(0,210,0,50)
content.Size = UDim2.new(1,-220,1,-60)
content.BackgroundTransparency = 1

local tabY = 0
local Window = {}

--------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------

function Window:CreateTab(name)

local tabButton = Instance.new("TextButton",sidebar)
tabButton.Size = UDim2.new(1,0,0,40)
tabButton.Position = UDim2.new(0,0,0,tabY)
tabButton.BackgroundTransparency = 1
tabButton.Text = name
tabButton.Font = Enum.Font.Gotham
tabButton.TextSize = 14
tabButton.TextColor3 = Color3.fromRGB(220,220,220)

tabY += 40

local page = Instance.new("ScrollingFrame",content)
page.Size = UDim2.new(1,0,1,0)
page.Visible = false
page.ScrollBarThickness = 4
page.CanvasSize = UDim2.new(0,0,0,0)
page.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",page)
layout.Padding = UDim.new(0,10)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+20)
end)

tabButton.MouseButton1Click:Connect(function()

for _,v in pairs(content:GetChildren()) do
if v:IsA("ScrollingFrame") then
v.Visible = false
end
end

page.Visible = true

end)

--------------------------------------------------
-- TAB OBJECT
--------------------------------------------------

local Tab = {}

--------------------------------------------------
-- BUTTON
--------------------------------------------------

function Tab:AddButton(text,callback)

local btn = Instance.new("TextButton",page)
btn.Size = UDim2.new(1,0,0,40)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.Text = text
btn.Font = Enum.Font.Gotham
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",btn)

btn.MouseButton1Click:Connect(callback)

end

--------------------------------------------------
-- TOGGLE
--------------------------------------------------

function Tab:AddToggle(text,callback)

local frame = Instance.new("Frame",page)
frame.Size = UDim2.new(1,0,0,40)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner",frame)

local label = Instance.new("TextLabel",frame)
label.Size = UDim2.new(1,-60,1,0)
label.Position = UDim2.new(0,10,0,0)
label.BackgroundTransparency = 1
label.Text = text
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextColor3 = Color3.new(1,1,1)
label.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("Frame",frame)
toggle.Size = UDim2.new(0,40,0,20)
toggle.Position = UDim2.new(1,-50,0.5,-10)
toggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
Instance.new("UICorner",toggle)

local circle = Instance.new("Frame",toggle)
circle.Size = UDim2.new(0,18,0,18)
circle.Position = UDim2.new(0,1,0,1)
circle.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner",circle)

local state = false

toggle.InputBegan:Connect(function()

state = not state

if state then
toggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
TweenService:Create(circle,TweenInfo.new(.2),{
Position = UDim2.new(1,-19,0,1)
}):Play()
else
toggle.BackgroundColor3 = Color3.fromRGB(90,90,90)
TweenService:Create(circle,TweenInfo.new(.2),{
Position = UDim2.new(0,1,0,1)
}):Play()
end

callback(state)

end)

end

return Tab

end

return Window

end

return Library
