
local p = game:GetService("Players").LocalPlayer
function get()
	local sync  = false
	for _,v in pairs(p:GetDescendants()) do
		if v.Name == "SyncAPI" then
			sync = v 
			break
		end
	end
	if not sync then
		for _,v in pairs(p.Character:GetDescendants()) do
			if v.Name == "SyncAPI" then
				sync = v 
				break
			end
		end
	end
	return sync
end
print("ran")
for _,v in pairs(workspace:GetDescendants()) do
	if v:IsA("Part") and v.Name == "PartRemover" then
		local args = {
			[1] = "SyncRotate",
			[2] = {
				[1] = {
					["Part"] = v,
					["CFrame"] = v.CFrame * CFrame.new(9e9,0,0) * CFrame.Angles(math.rad(90),0,0)
				}
			}
		}

		if not get() then return end
		get().ServerEndpoint:InvokeServer(unpack(args))

	end
end

function no(a)

	local args = {
		[1] = "SyncCollision",
		[2] = {
			[1] = {
				["Part"] = a,
				["CanCollide"] = false 
			}
		}
	}

	if not get() then return end
	get().ServerEndpoint:InvokeServer(unpack(args))
end
function make()
	local args = {
		[1] = "CreatePart",
		[2] = "Normal",
		[3] = CFrame.new(0,0,0),
		[4] = workspace
	}

	if not get() then return end
	return get().ServerEndpoint:InvokeServer(unpack(args))
end
function size(p,v)

	local args = {
		[1] = "SyncResize",
		[2] = {
			[1] = {
				["Part"] = p,
				["CFrame"] = p.CFrame,
				["Size"] = v
			}
		}
	}

	if not get() then return end
	get().ServerEndpoint:InvokeServer(unpack(args))

end
function weld(p0,p1)
	if not get() then return end
	local welds = {}
	for _,v in pairs(p0:GetChildren()) do
		if v:IsA("Weld") then
			table.insert(welds,v)
		end
	end

	local args = {
		[1] = "RemoveWelds",
		[2] = welds,
	}
	get().ServerEndpoint:InvokeServer(unpack(args))
	task.wait()

	args = {
			[1] = "CreateWelds",
			[2] = {
				[1] = p0
			},
			[3] = p1
		}
	get().ServerEndpoint:InvokeServer(unpack(args))
end

function move(p,c)
	local args = {
		[1] = "SyncMove",
		[2] = {
			[1] = {
				["Part"] = p,
				["CFrame"] = c
			}
		}
	}
	if not get() then return end
	get().ServerEndpoint:InvokeServer(unpack(args))

end
function anchor(p,b)
	local args = {
		[1] = "SyncAnchor",
		[2] = {
			[1] = {
				["Part"] = p,
				["Anchored"] = b
			}
		}
	}
	if not get() then return end
	get().ServerEndpoint:InvokeServer(unpack(args))

end
local re = false
p.CharacterRemoving:Once(function()
	re = true
end)
local a = {}
function rem(a)
	if not get() then return end
	get().ServerEndpoint:InvokeServer("Remove",{a})
end
for _,v in pairs(p.Character:GetChildren()) do
	if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
		task.spawn(function() 
			local clone = make()
			size(clone,v.Size)
			move(clone,v.CFrame)
			weld(clone,v)
			
			a[v.Name] = {clone,v}
			no(clone)

			anchor(clone,false)
		end)
	end
end
ta = game:GetService("RunService").Heartbeat:Connect(function()
	for _,v in pairs(a) do
		rem(v[1])
		local clone = make()
		size(clone,v.Size)
		move(clone,v.CFrame)
		weld(clone,v)

		a[v[2].Name] = {clone,v[2]}
		no(clone)

		anchor(clone,false)
	end
end)
repeat task.wait()
until re
ta:Disconnect()
