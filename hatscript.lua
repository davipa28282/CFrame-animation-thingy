for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
	if v.Name == "HMASTER" then v:Destroy() end
end
local HMASTER = Instance.new("ScreenGui")
local MainMover = Instance.new("Frame")
local ScrollingFrame = Instance.new("ScrollingFrame")
local listingsystem = Instance.new("UIListLayout")
local Buttons = Instance.new("Frame")
local Run = Instance.new("TextButton")
local SelectedMode = Instance.new("TextLabel")
local Credit = Instance.new("TextLabel")
local TextLabel = Instance.new("TextLabel")
local TemplateButton = Instance.new("TextButton")
HMASTER.Name = "HMASTER"
HMASTER.Parent = game:GetService("CoreGui")
HMASTER.IgnoreGuiInset = true
HMASTER.DisplayOrder = 90

MainMover.Name = "MainMover"
MainMover.Parent = HMASTER
MainMover.Active = true
MainMover.AnchorPoint = Vector2.new(0.5, 0.5)
MainMover.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
MainMover.BackgroundTransparency = 0.550
MainMover.BorderColor3 = Color3.fromRGB(255, 233, 143)
MainMover.BorderSizePixel = 5
MainMover.Position = UDim2.new(0.5, 0, 0.5, 0)
MainMover.Size = UDim2.new(0, 198, 0, 25)

ScrollingFrame.Parent = MainMover
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
ScrollingFrame.BackgroundTransparency = 0.650
ScrollingFrame.BorderColor3 = Color3.fromRGB(156, 152, 35)
ScrollingFrame.BorderSizePixel = 5
ScrollingFrame.Position = UDim2.new(0, 0, 1.28794312, 0)
ScrollingFrame.Size = UDim2.new(0, 198, 0, 216)

listingsystem.Name = "listingsystem"
listingsystem.Parent = ScrollingFrame
listingsystem.HorizontalAlignment = Enum.HorizontalAlignment.Center
listingsystem.SortOrder = Enum.SortOrder.LayoutOrder
listingsystem.VerticalAlignment = Enum.VerticalAlignment.Center
listingsystem.Padding = UDim.new(0, 5)

Buttons.Name = "Buttons"
Buttons.Parent = MainMover
Buttons.BackgroundColor3 = Color3.fromRGB(255, 238, 0)
Buttons.BackgroundTransparency = 0.350
Buttons.BorderColor3 = Color3.fromRGB(173, 167, 0)
Buttons.BorderSizePixel = 3
Buttons.Position = UDim2.new(0, 0, 10.168705, 0)
Buttons.Size = UDim2.new(0, 198, 0, 60)

Run.Name = "Run"
Run.Parent = Buttons
Run.BackgroundColor3 = Color3.fromRGB(244, 235, 132)
Run.BackgroundTransparency = 0.500
Run.BorderColor3 = Color3.fromRGB(0, 0, 0)
Run.BorderSizePixel = 2
Run.Position = UDim2.new(0.196773648, 0, 0.193078607, 0)
Run.Size = UDim2.new(0, 120, 0, 13)
Run.Font = Enum.Font.SourceSans
Run.Text = "Run Selected HatScript"
Run.TextColor3 = Color3.fromRGB(0, 0, 0)
Run.TextSize = 14.000

SelectedMode.Name = "SelectedMode"
SelectedMode.Parent = Buttons
SelectedMode.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SelectedMode.BackgroundTransparency = 1.000
SelectedMode.BorderColor3 = Color3.fromRGB(0, 0, 0)
SelectedMode.BorderSizePixel = 0
SelectedMode.Position = UDim2.new(0.191919193, 0, 0.545833349, 0)
SelectedMode.Size = UDim2.new(0, 120, 0, 21)
SelectedMode.Font = Enum.Font.SourceSans
SelectedMode.Text = "Selected: None"
SelectedMode.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedMode.TextScaled = true
SelectedMode.TextSize = 14.000
SelectedMode.TextWrapped = true
SelectedMode.TextXAlignment = Enum.TextXAlignment.Left

Credit.Name = "Credit"
Credit.Parent = MainMover
Credit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credit.BackgroundTransparency = 1.000
Credit.BorderColor3 = Color3.fromRGB(0, 0, 0)
Credit.BorderSizePixel = 0
Credit.Position = UDim2.new(0, 0, -1.0955224, 0)
Credit.Size = UDim2.new(0, 198, 0, 27)
Credit.Font = Enum.Font.SourceSans
Credit.Text = "HatMaster by hs_prototype and rex_gtag"
Credit.TextColor3 = Color3.fromRGB(255, 255, 255)
Credit.TextScaled = true
Credit.TextSize = 14.000
Credit.TextWrapped = true

TextLabel.Parent = MainMover
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(1.23303346e-06, 0, -0.196633294, 0)
TextLabel.Size = UDim2.new(0, 89, 0, 35)
TextLabel.Font = Enum.Font.Unknown
TextLabel.Text = "HATMASTER"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

TemplateButton.Name = "TemplateButton"
TemplateButton.BackgroundColor3 = Color3.fromRGB(244, 235, 132)
TemplateButton.BackgroundTransparency = 0.500
TemplateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TemplateButton.BorderSizePixel = 2
TemplateButton.Position = UDim2.new(0.0957635418, 0, 0.438911706, 0)
TemplateButton.Size = UDim2.new(0, 160, 0, 26)
TemplateButton.Font = Enum.Font.SourceSans
TemplateButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TemplateButton.TextSize = 14.000
local CurrentSelection = "None"
local Order = 0
local CurrentCallback = function()

end
local RunM = Run.Activated:Connect(CurrentCallback)
function Update()
	SelectedMode.Text = "Selected: ".. CurrentSelection
	RunM:Disconnect()
	RunM = Run.Activated:Connect(CurrentCallback)
end
function AddMode(Name,Callback)
	local Button = TemplateButton:Clone()
	Button.Text = Name
	Button.LayoutOrder = Order
	Order += 1
	Button.Activated:Connect(function()
		CurrentCallback = Callback
		CurrentSelection = Name
		Update()
	end)
	Button.Parent = ScrollingFrame
end

function DropHats()
	local fph = workspace.FallenPartsDestroyHeight

	local plr = game.Players.LocalPlayer
	local character = plr.Character
	local hrp = character:WaitForChild("HumanoidRootPart")
	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	local start = hrp.CFrame

	local campart = Instance.new("Part",character)
	campart.Transparency = 1
	campart.CanCollide = false
	campart.Size = Vector3.one
	campart.Position = start.Position
	campart.Anchored = true

	local function updatestate(hat,state)
		if sethiddenproperty then
			sethiddenproperty(hat,"BackendAccoutrementState",state)
		elseif setscriptable then
			setscriptable(hat,"BackendAccoutrementState",true)
			hat.BackendAccoutrementState = state
		else
			local success = pcall(function()
				hat.BackendAccoutrementState = state
			end)
			if not success then
				error("executor not supported, sorry!")
			end
		end
	end

	local allhats = {}
	for i,v in pairs(character:GetChildren()) do
		if v:IsA("Accessory") then
			table.insert(allhats,v)
		end
	end

	local locks = {}
	for i,v in pairs(allhats) do
		table.insert(locks,v.Changed:Connect(function(p)
			if p == "BackendAccoutrementState" then
				updatestate(v,0)
			end
		end))
		updatestate(v,2)
	end

	workspace.FallenPartsDestroyHeight = 0/0

	local function play(id,speed,prio,weight)
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "https"..tostring(math.random(1000000,9999999)).."="..tostring(id)
		local track = character.Humanoid:LoadAnimation(Anim)
		track.Priority = prio
		track:Play()
		track:AdjustSpeed(speed)
		track:AdjustWeight(weight)
		return track
	end

	local r6fall = 180436148
	local r15fall = 507767968

	local dropcf = CFrame.new(character.HumanoidRootPart.Position.x,fph-.25,character.HumanoidRootPart.Position.z)
	if character.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		dropcf =  dropcf * CFrame.Angles(math.rad(20),0,0)
		character.Humanoid:ChangeState(16)
		play(r15fall,1,5,1).TimePosition = .1
	else
		play(r6fall,1,5,1).TimePosition = .1
	end

	spawn(function()
		while hrp.Parent ~= nil do
			hrp.CFrame = dropcf
			hrp.Velocity = Vector3.new(0,25,0)
			hrp.RotVelocity = Vector3.new(0,0,0)
			game:GetService("RunService").Heartbeat:wait()
		end
	end)

	task.wait(.25)
	character.Humanoid:ChangeState(15)
	torso.AncestryChanged:wait()

	for i,v in pairs(locks) do
		v:Disconnect()
	end
	for i,v in pairs(allhats) do
		updatestate(v,4)
	end

	spawn(function()
		plr.CharacterAdded:wait():WaitForChild("HumanoidRootPart",10).CFrame = start
		workspace.FallenPartsDestroyHeight = fph
		workspace.CurrentCamera.CameraSubject = plr.Character
	end)

	local dropped = false
	repeat
		local foundhandle = false
		for i,v in pairs(allhats) do
			if v:FindFirstChild("Handle") then
				foundhandle = true
				if v.Handle.CanCollide then
					dropped = true
					break
				end
			end
		end
		if not foundhandle then
			break
		end
		task.wait()
	until plr.Character ~= character or dropped

	if dropped then
		return allhats, start
	else
		return false
	end
end
MainMover.Draggable = true
MainMover.Active = true
local isdropped = false
local CamPart = Instance.new("Part",workspace)
CamPart.Anchored = true
CamPart.Size = Vector3.one
CamPart.Transparency = 1
CamPart.CanCollide = false
CamPart.Name = "CameraPart"
CamPart.CFrame = CFrame.new(0,0,0)
local Respawn = false
local busy = false
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
	busy = false	
	Respawn = true
end)
AddMode("Permadeath/Respawn",function()
	replicatesignal(game.Players.LocalPlayer.ConnectDiedSignalBackend)
end)
AddMode("Land Mine",function()
	if busy then return end
	busy = true
	local Hats,Position = DropHats()
	if not Hats then return end
	local Respawn = false
	local MainHat = Hats[math.random(1,#Hats)]
	repeat MainHat = Hats[math.random(1,#Hats)] task.wait()
	until MainHat and MainHat:FindFirstChild("Handle") and MainHat:FindFirstChild("Handle").CanCollide
	MainHat = MainHat:FindFirstChild("Handle")
	MainHat.Touched:Connect(function(base)
		if base.Parent and base.Parent:FindFirstChildOfClass("Humanoid") and not base:IsDescendantOf(game:GetService("Players").LocalPlayer.Character) then
			Respawn = true
			MainHat.Velocity = Vector3.new(math.random(-25,25),15,math.random(-25,25))
			Respawn = false
			task.wait(0.1)
			repeat task.wait()
				for _,v in pairs(Hats) do
					local Handle = v:FindFirstChild("Handle")
					if Handle then
						local r = base.Parent:FindFirstChild("HumanoidRootPart")
						if r then
							local Random = 2.5 + r.Velocity.Magnitude/5.5
							local Vel = r.Velocity/1.125
							Handle.CFrame = CFrame.new(r.Position) * CFrame.new(Vector3.new(Vel.X,Vel.Y*2.5,Vel.Z)) * CFrame.new(math.random(-Random,Random),math.random(-Random,Random),math.random(-Random,Random))
							Handle.Velocity = Vector3.new(90000,90000,90000)	
						end
					end
				end
			until Respawn
		end
	end)

	repeat task.wait()

		CamPart.CFrame = Position
		for _,v in pairs(Hats) do
			local Handle = v:FindFirstChild("Handle")
			if Handle and Handle.CanCollide and Handle ~= MainHat then
				Handle.CFrame = Position * CFrame.new(0,-7,0)
				Handle.Velocity = Vector3.new(0,50,0)
			elseif Handle == MainHat then
				Handle.CFrame = Position * CFrame.new(0,-2.5,0)
			end
		end
	until Respawn
	game:GetService("Players").LocalPlayer.CharacterAppearanceLoaded:Wait()
	workspace.CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character	
	busy = false	
end)
AddMode("Hatxplode yourself", function()
	if not busy then busy = true else return end
	local Hats,Pos = DropHats()
	if not Hats then return end
	Respawn = false
	for _,v in pairs(Hats) do
		local Handle = v:FindFirstChild("Handle")
		if Handle and Handle.CanCollide then
			Handle.CFrame = Pos
			Handle.Velocity = Vector3.new(math.random(-25,25),25,math.random(-25,25))
		end
	end
	wait(0.5)
	repeat task.wait()
		CamPart.CFrame = Pos
	until Respawn
end)

game:GetService("RunService").RenderStepped:Connect(function()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	if not busy then
		local Head = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head")
		if Head then
			workspace.CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		end
	else
		workspace.CurrentCamera.CameraSubject = CamPart
	end
end)
