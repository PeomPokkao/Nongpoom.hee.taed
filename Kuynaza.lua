-- POOM ADMIN ULTRA+

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn = false

------------------------------------------------
-- OPEN BUTTON
------------------------------------------------

local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,120,0,36)
open.Position = UDim2.new(0,20,0.5,0)
open.Text = "OPEN UI"
open.BackgroundColor3 = Color3.fromRGB(40,40,40)
open.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",open).CornerRadius = UDim.new(0,10)
open.Visible = false

------------------------------------------------
-- MAIN UI
------------------------------------------------

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,640,0,380)
main.Position = UDim2.new(.5,-320,.5,-190)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BackgroundTransparency = .1
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,14)

------------------------------------------------
-- GLOW EFFECT
------------------------------------------------

local stroke = Instance.new("UIStroke",main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,170,255)

task.spawn(function()

while true do

TweenService:Create(stroke,TweenInfo.new(2),{
Color = Color3.fromRGB(255,0,255)
}):Play()

task.wait(2)

TweenService:Create(stroke,TweenInfo.new(2),{
Color = Color3.fromRGB(0,170,255)
}):Play()

task.wait(2)

end

end)

------------------------------------------------
-- GRADIENT
------------------------------------------------

local grad = Instance.new("UIGradient",main)
grad.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.fromRGB(35,35,35)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(10,10,10))
}

------------------------------------------------
-- TOPBAR
------------------------------------------------

local top = Instance.new("Frame",main)
top.Size = UDim2.new(1,0,0,36)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel",top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Poom Admin"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

------------------------------------------------
-- CLOSE
------------------------------------------------

local close = Instance.new("TextButton",top)
close.Size = UDim2.new(0,28,0,28)
close.Position = UDim2.new(1,-32,0,4)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200,70,70)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()

TweenService:Create(main,TweenInfo.new(.25),{
Size = UDim2.new(0,0,0,0)
}):Play()

task.wait(.25)

main.Visible=false
open.Visible=true
main.Size = UDim2.new(0,640,0,380)

end)

------------------------------------------------
-- OPEN
------------------------------------------------

open.MouseButton1Click:Connect(function()

main.Visible=true
open.Visible=false

main.Size = UDim2.new(0,0,0,0)

TweenService:Create(main,TweenInfo.new(.25),{
Size = UDim2.new(0,640,0,380)
}):Play()

end)

------------------------------------------------
-- HOTKEY
------------------------------------------------

UIS.InputBegan:Connect(function(i)

if i.KeyCode == Enum.KeyCode.RightShift then

if main.Visible then
close:Activate()
else
open:Activate()
end

end

end)

------------------------------------------------
-- CONTENT
------------------------------------------------

local content = Instance.new("ScrollingFrame",main)
content.Size = UDim2.new(1,-40,1,-60)
content.Position = UDim2.new(0,20,0,50)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0,0,0,800)

local layout = Instance.new("UIListLayout",content)
layout.Padding = UDim.new(0,10)

------------------------------------------------
-- NEON TOGGLE
------------------------------------------------

local function Toggle(name)

local frame = Instance.new("Frame",content)
frame.Size = UDim2.new(1,0,0,40)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner",frame)

local text = Instance.new("TextLabel",frame)
text.Text = name
text.Size = UDim2.new(.7,0,1,0)
text.Position = UDim2.new(0,12,0,0)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.Font = Enum.Font.Gotham
text.TextSize = 14
text.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("Frame",frame)
toggle.Size = UDim2.new(0,44,0,20)
toggle.Position = UDim2.new(1,-60,.5,-10)
toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

local circle = Instance.new("Frame",toggle)
circle.Size = UDim2.new(0,18,0,18)
circle.Position = UDim2.new(0,1,0,1)
circle.BackgroundColor3 = Color3.new(1,1,1)
Instance.new("UICorner",circle).CornerRadius = UDim.new(1,0)

local state=false

toggle.InputBegan:Connect(function()

state=not state

if state then

toggle.BackgroundColor3 = Color3.fromRGB(0,255,170)

TweenService:Create(circle,TweenInfo.new(.2),{
Position = UDim2.new(1,-19,0,1)
}):Play()

else

toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)

TweenService:Create(circle,TweenInfo.new(.2),{
Position = UDim2.new(0,1,0,1)
}):Play()

end

end)

end

------------------------------------------------
-- SMOOTH SLIDER
------------------------------------------------

local function Slider(name)

local frame = Instance.new("Frame",content)
frame.Size = UDim2.new(1,0,0,50)
frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner",frame)

local text = Instance.new("TextLabel",frame)
text.Text = name
text.Size = UDim2.new(1,-20,0,20)
text.Position = UDim2.new(0,10,0,4)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.Font = Enum.Font.Gotham
text.TextSize = 14
text.TextXAlignment = Enum.TextXAlignment.Left

local bar = Instance.new("Frame",frame)
bar.Size = UDim2.new(1,-20,0,6)
bar.Position = UDim2.new(0,10,0,30)
bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner",bar)

local fill = Instance.new("Frame",bar)
fill.Size = UDim2.new(0,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner",fill)

bar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1 then

while UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do

local pos = UIS:GetMouseLocation().X
local percent = math.clamp((pos-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)

fill.Size = UDim2.new(percent,0,1,0)

task.wait()

end

end

end)

end

------------------------------------------------
-- SAMPLE
------------------------------------------------

Toggle("Auto Rejoin")

Toggle("Auto Farm")

Slider("WalkSpeed")
