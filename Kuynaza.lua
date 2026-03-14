-- POOM ORION STYLE UI

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

------------------------------------------------
-- OPEN BUTTON
------------------------------------------------

local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,90,0,30)
open.Position = UDim2.new(0,20,0.5,0)
open.Text="OPEN UI"
open.BackgroundColor3 = Color3.fromRGB(40,40,40)
open.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",open)

------------------------------------------------
-- MAIN UI
------------------------------------------------

local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,520,0,320)
main.Position = UDim2.new(.5,-260,.5,-160)
main.BackgroundColor3 = Color3.fromRGB(28,28,28)
main.Active=true
main.Draggable=true
Instance.new("UICorner",main)

------------------------------------------------
-- CLOSE BUTTON
------------------------------------------------

local close = Instance.new("TextButton",main)
close.Size = UDim2.new(0,28,0,24)
close.Position = UDim2.new(1,-34,0,4)
close.Text="-"
close.BackgroundColor3 = Color3.fromRGB(60,60,60)
close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()

TweenService:Create(main,TweenInfo.new(.2),{
Size = UDim2.new(0,0,0,0)
}):Play()

task.wait(.2)

main.Visible=false
open.Visible=true
main.Size = UDim2.new(0,520,0,320)

end)

open.MouseButton1Click:Connect(function()

main.Visible=true
open.Visible=false

main.Size = UDim2.new(0,0,0,0)

TweenService:Create(main,TweenInfo.new(.2),{
Size = UDim2.new(0,520,0,320)
}):Play()

end)

------------------------------------------------
-- SIDEBAR
------------------------------------------------

local sidebar = Instance.new("Frame",main)
sidebar.Size = UDim2.new(0,60,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)

local sideLayout = Instance.new("UIListLayout",sidebar)
sideLayout.Padding = UDim.new(0,6)

------------------------------------------------
-- CONTENT AREA
------------------------------------------------

local content = Instance.new("Frame",main)
content.Position = UDim2.new(0,60,0,0)
content.Size = UDim2.new(1,-60,1,0)
content.BackgroundTransparency=1

local pages={}

------------------------------------------------
-- NOTIFICATION
------------------------------------------------

function Notify(text)

local n = Instance.new("TextLabel",gui)
n.Size = UDim2.new(0,220,0,32)
n.Position = UDim2.new(1,-240,1,-60)
n.BackgroundColor3 = Color3.fromRGB(35,35,35)
n.TextColor3 = Color3.new(1,1,1)
n.Text = text
Instance.new("UICorner",n)

n.TextTransparency=1

TweenService:Create(n,TweenInfo.new(.25),{
TextTransparency=0
}):Play()

task.wait(2)

TweenService:Create(n,TweenInfo.new(.25),{
TextTransparency=1
}):Play()

task.wait(.25)

n:Destroy()

end

------------------------------------------------
-- CREATE TAB
------------------------------------------------

function CreateTab(name)

local btn = Instance.new("TextButton",sidebar)
btn.Size = UDim2.new(0,40,0,40)
btn.Text=""
btn.BackgroundColor3 = Color3.fromRGB(45,45,45)

local corner = Instance.new("UICorner",btn)
corner.CornerRadius = UDim.new(1,0)

local icon = Instance.new("TextLabel",btn)
icon.Size = UDim2.new(1,0,1,0)
icon.BackgroundTransparency=1
icon.Text=string.sub(name,1,1)
icon.TextColor3=Color3.new(1,1,1)
icon.Font=Enum.Font.GothamBold
icon.TextSize=16

local page = Instance.new("ScrollingFrame",content)
page.Size=UDim2.new(1,0,1,0)
page.BackgroundTransparency=1
page.Visible=false
page.ScrollBarThickness=4

local layout=Instance.new("UIListLayout",page)
layout.Padding=UDim.new(0,6)

pages[name]=page

btn.MouseButton1Click:Connect(function()

for _,p in pairs(pages) do
p.Visible=false
end

page.Visible=true

TweenService:Create(btn,TweenInfo.new(.2),{
BackgroundColor3=Color3.fromRGB(0,170,255)
}):Play()

task.wait(.2)

TweenService:Create(btn,TweenInfo.new(.2),{
BackgroundColor3=Color3.fromRGB(45,45,45)
}):Play()

end)

return page

end

------------------------------------------------
-- BUTTON
------------------------------------------------

function Button(tab,name,callback)

local b = Instance.new("TextButton",tab)
b.Size = UDim2.new(1,-10,0,30)
b.Text=name
b.BackgroundColor3 = Color3.fromRGB(50,50,50)
b.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",b)

b.MouseButton1Click:Connect(function()

Notify(name)

if callback then
callback()
end

end)

end

------------------------------------------------
-- TOGGLE
------------------------------------------------

function Toggle(tab,name,callback)

local frame = Instance.new("Frame",tab)
frame.Size=UDim2.new(1,-10,0,32)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner",frame)

local text = Instance.new("TextLabel",frame)
text.Size=UDim2.new(.7,0,1,0)
text.Text=name
text.BackgroundTransparency=1
text.TextColor3=Color3.new(1,1,1)

local toggle = Instance.new("Frame",frame)
toggle.Size=UDim2.new(0,40,0,18)
toggle.Position=UDim2.new(1,-50,.5,-9)
toggle.BackgroundColor3=Color3.fromRGB(70,70,70)
Instance.new("UICorner",toggle)

local circle = Instance.new("Frame",toggle)
circle.Size=UDim2.new(0,16,0,16)
circle.Position=UDim2.new(0,1,0,1)
circle.BackgroundColor3=Color3.new(1,1,1)
Instance.new("UICorner",circle)

local state=false

toggle.InputBegan:Connect(function()

state=not state

if state then

TweenService:Create(circle,TweenInfo.new(.2),{
Position=UDim2.new(1,-17,0,1)
}):Play()

toggle.BackgroundColor3=Color3.fromRGB(0,170,255)

else

TweenService:Create(circle,TweenInfo.new(.2),{
Position=UDim2.new(0,1,0,1)
}):Play()

toggle.BackgroundColor3=Color3.fromRGB(70,70,70)

end

Notify(name.." : "..tostring(state))

if callback then
callback(state)
end

end)

end

------------------------------------------------
-- TEXTBOX
------------------------------------------------

function Textbox(tab,name,callback)

local box = Instance.new("TextBox",tab)
box.Size=UDim2.new(1,-10,0,30)
box.PlaceholderText=name
box.BackgroundColor3 = Color3.fromRGB(45,45,45)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",box)

box.FocusLost:Connect(function()

if callback then
callback(box.Text)
end

end)

end

------------------------------------------------
-- DROPDOWN
------------------------------------------------

function Dropdown(tab,name,list)

local frame = Instance.new("Frame",tab)
frame.Size=UDim2.new(1,-10,0,30)
frame.BackgroundColor3=Color3.fromRGB(40,40,40)
Instance.new("UICorner",frame)

local button = Instance.new("TextButton",frame)
button.Size=UDim2.new(1,0,1,0)
button.Text=name
button.BackgroundTransparency=1
button.TextColor3=Color3.new(1,1,1)

button.MouseButton1Click:Connect(function()

for _,v in pairs(list) do

local opt = Instance.new("TextButton",tab)
opt.Size=UDim2.new(1,-10,0,26)
opt.Text=v
opt.BackgroundColor3=Color3.fromRGB(50,50,50)
opt.TextColor3=Color3.new(1,1,1)
Instance.new("UICorner",opt)

opt.MouseButton1Click:Connect(function()

Notify("Selected "..v)

end)

end

end)

end
