-- SMART CHEST FARM (NO ESP)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local Farm = false
local ChestCollected = 0
local FODCollected = 0

local FootPart
local Tween

-------------------------------------------------
-- UI
-------------------------------------------------

local gui = Instance.new("ScreenGui",game.CoreGui)

local open = Instance.new("TextButton",gui)
open.Size = UDim2.new(0,50,0,50)
open.Position = UDim2.new(0,20,0.5,-25)
open.Text = "≡"

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0,220,0,170)
frame.Position = UDim2.new(0,80,0.5,-85)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false

open.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local farmBtn = Instance.new("TextButton",frame)
farmBtn.Size = UDim2.new(1,-10,0,30)
farmBtn.Position = UDim2.new(0,5,0,5)
farmBtn.Text = "Chest Farm : OFF"

local chestLabel = Instance.new("TextLabel",frame)
chestLabel.Size = UDim2.new(1,0,0,20)
chestLabel.Position = UDim2.new(0,0,0,50)
chestLabel.BackgroundTransparency = 1
chestLabel.TextColor3 = Color3.new(1,1,1)
chestLabel.Text = "Chest : 0"

local fodLabel = Instance.new("TextLabel",frame)
fodLabel.Size = UDim2.new(1,0,0,20)
fodLabel.Position = UDim2.new(0,0,0,75)
fodLabel.BackgroundTransparency = 1
fodLabel.TextColor3 = Color3.new(1,1,1)
fodLabel.Text = "First Of Darkness : 0"

-------------------------------------------------
-- FOOT PLATFORM
-------------------------------------------------

local function CreateFoot()

	if FootPart then return end

	local root = player.Character:WaitForChild("HumanoidRootPart")

	FootPart = Instance.new("Part")
	FootPart.Size = Vector3.new(6,0.5,6)
	FootPart.Material = Enum.Material.Neon
	FootPart.CanCollide = false
	FootPart.Parent = workspace

	RunService.RenderStepped:Connect(function()

		if FootPart and root then
			FootPart.CFrame = root.CFrame * CFrame.new(0,-3,0)
			FootPart.Color = Color3.fromHSV(tick()%5/5,1,1)
		end

	end)

end

local function RemoveFoot()

	if FootPart then
		FootPart:Destroy()
		FootPart = nil
	end

end

-------------------------------------------------
-- FIND CHESTS
-------------------------------------------------

local function GetAllChests()

	local list = {}

	for _,v in pairs(workspace:GetDescendants()) do

		if v.Name:lower():find("chest") then

			local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")

			if part then
				table.insert(list,part)
			end

		end

	end

	return list

end

-------------------------------------------------
-- NEAREST CHEST
-------------------------------------------------

local function GetNearestChest()

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local nearest
	local distance = math.huge

	for _,chest in pairs(GetAllChests()) do

		local dist = (root.Position - chest.Position).Magnitude

		if dist < distance then
			distance = dist
			nearest = chest
		end

	end

	return nearest

end

-------------------------------------------------
-- FLY
-------------------------------------------------

local function FlyTo(chest)

	local root = player.Character:FindFirstChild("HumanoidRootPart")

	local dist = (root.Position - chest.Position).Magnitude

	Tween = TweenService:Create(
		root,
		TweenInfo.new(dist/120,Enum.EasingStyle.Linear),
		{CFrame = chest.CFrame + Vector3.new(0,3,0)}
	)

	Tween:Play()
	Tween.Completed:Wait()

	ChestCollected += 1
	chestLabel.Text = "Chest : "..ChestCollected

end

-------------------------------------------------
-- FIRST OF DARKNESS
-------------------------------------------------

player.Backpack.ChildAdded:Connect(function(item)

	if item.Name:lower():find("darkness") then

		FODCollected += 1
		fodLabel.Text = "First Of Darkness : "..FODCollected

	end

end)

-------------------------------------------------
-- FARM LOOP
-------------------------------------------------

local function StartFarm()

	while Farm do

		local chest = GetNearestChest()

		if chest then
			FlyTo(chest)
		else
			task.wait(1)
		end

	end

end

-------------------------------------------------
-- BUTTON
-------------------------------------------------

farmBtn.MouseButton1Click:Connect(function()

	Farm = not Farm
	farmBtn.Text = "Chest Farm : "..(Farm and "ON" or "OFF")

	if Farm then
		CreateFoot()
		task.spawn(StartFarm)
	else
		RemoveFoot()
	end

end)
