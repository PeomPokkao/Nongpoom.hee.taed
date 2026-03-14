function Dropdown(tab,name,list,callback)

local frame = Instance.new("Frame",tab)
frame.Size=UDim2.new(1,-10,0,26)
frame.BackgroundColor3=Color3.fromRGB(40,40,40)

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

local button = Instance.new("TextButton",frame)
button.Size=UDim2.new(1,0,1,0)
button.Text=name
button.BackgroundTransparency=1
button.TextColor3=Color3.new(1,1,1)

local container = Instance.new("Frame",tab)
container.Size=UDim2.new(1,-10,0,0)
container.BackgroundTransparency=1
container.ClipsDescendants=true

local layout=Instance.new("UIListLayout",container)
layout.Padding=UDim.new(0,4)

local opened=false
local options={}

------------------------------------------------
-- CREATE OPTION
------------------------------------------------

local function createOption(v)

local opt = Instance.new("TextButton",container)
opt.Size=UDim2.new(1,0,0,24)
opt.Text=v
opt.BackgroundColor3=Color3.fromRGB(50,50,50)
opt.TextColor3=Color3.new(1,1,1)

Instance.new("UICorner",opt).CornerRadius = UDim.new(0,8)

opt.MouseButton1Click:Connect(function()

button.Text = v

if callback then
callback(v)
end

container.Size = UDim2.new(1,-10,0,0)
opened=false

end)

table.insert(options,opt)

end

------------------------------------------------
-- INITIAL LIST
------------------------------------------------

for _,v in pairs(list) do
createOption(v)
end

------------------------------------------------
-- OPEN CLOSE
------------------------------------------------

button.MouseButton1Click:Connect(function()

opened = not opened

local size = opened and (#options*28) or 0

game:GetService("TweenService"):Create(container,
TweenInfo.new(.25),
{Size=UDim2.new(1,-10,0,size)}
):Play()

end)

------------------------------------------------
-- REFRESH FUNCTION
------------------------------------------------

local dropdown={}

function dropdown:Refresh(newList)

for _,v in pairs(options) do
v:Destroy()
end

options={}

for _,v in pairs(newList) do
createOption(v)
end

end

return dropdown

end
