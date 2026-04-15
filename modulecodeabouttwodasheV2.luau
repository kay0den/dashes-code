local Manager = {}



function Manager.rare_dash(player,character,profile)
	
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local remote = replicatedStorage.movment_events:WaitForChild("Dashremote")
	local dasheff = replicatedStorage.Effects.Dasheff
	local cooldown = false
	local datamanager = require(game.ServerScriptService.Data.DataManager)
	local verifydash = datamanager.VerifyDash(profile.Data)
	if verifydash ~= "basic_dash" then return end
	if profile.Data.EquippedDash ~= "basic_dash" then return end

	if character.verify.runningboolean.Value == false then return end
	if character.verify.stun.Value == true then return end
	if cooldown == true then return end
	cooldown = true
	task.delay(1.5,function()
		cooldown = false
	end)

	character.Humanoid.WalkSpeed = 70
	local hrb = character:FindFirstChild("HumanoidRootPart")
	local dash = dasheff:Clone()
	dash.Parent = workspace
	dash.CFrame = hrb.CFrame
	dash.Anchored = false
	local weld = Instance.new("WeldConstraint")
	weld.Parent = dash
	weld.Part0 = hrb
	weld.Part1 = dash
	for _,v in character:GetDescendants() do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end
	task.delay(0.7,function()
		dash:Destroy()
		if character.verify.isrunningfordashes.Value == true then

			character.Humanoid.WalkSpeed = 33
		else

			character.Humanoid.WalkSpeed = 13
		end
		for _,v in character:GetDescendants() do
			if v:IsA("BasePart") then
				v.Transparency = 0
				character.testsword.Mhandle.Handle.Transparency = 1
				character.testsword.Mhandle.Handle.trialsword.Transparency = 1
				hrb.Transparency = 1
				if character.verify.usingsword.Value == false then
					character.testsword.Mhandle.Handle.Katana.Transparency = 1

				else
					character.testsword.theswordinsheath.Sheath.Katana.Transparency = 1
				end
			end
		end
	end)
end

-------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------


function Manager.basic_dash(player,character,profile)
	
	 if character:GetAttribute("Blocking") ~= nil then return end
	 if character:GetAttribute("State") == "Stun" then return end
	if character:GetAttribute("Usingsword") ~= "true" then return end
	 if character:GetAttribute("Usingskill") ~= nil then return end
	 
	 
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local dasheff = replicatedStorage.Effects.Dasheff
	local cooldown = false
	local datamanager = require(game.ServerScriptService.Data.DataManager)
	local verifydash = datamanager.VerifyDash(profile.Data)
	
	-- ✨ verify and cooldown ✨--
	
	if verifydash ~= "basic_dash" then 
		profile.Data.EquippedDash = verifydash
		local remote = replicatedStorage.movment_events:WaitForChild("Dashremote")
		remote:FireClient(player,character)
		return
	end
	
	if profile.Data.EquippedDash ~= "basic_dash" then return end	
	
	
	if cooldown == true then return end
	cooldown = true
	task.delay(3,function()
		cooldown = false
	end)
	replicatedStorage:WaitForChild("combat_events"):WaitForChild("raredashEvent"):FireClient(player)
	local dash_is_playing = character.verify.dash_is_playing.Value 
	dash_is_playing = true
	local hrp = character:FindFirstChild("HumanoidRootPart")
	local thedashend = replicatedStorage:WaitForChild("combat_events"):WaitForChild("raredashEventend")
	
	
	
	
	------------------------------------------------------------------ ✨the effects✨ --
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Debris = game:GetService("Debris")

	local Effects = ReplicatedStorage:WaitForChild("Effects")

	local firsteff = Effects:WaitForChild("RareDash_first_emit")
	local secondEff = Effects:WaitForChild("RareDash_Smoke_eff")
	local thirdEff = Effects:WaitForChild("RareDash_theslash")

	-- Clone
	local firstclone = firsteff:Clone()
	local secondclone = secondEff:Clone()
	local thirdclone = thirdEff:Clone()

	-- Parent
	firstclone.Parent = workspace
	secondclone.Parent = hrp
	thirdclone.Parent = workspace

	-- Position 
	firstclone.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
	secondclone.Position = hrp.Position
	local weld = Instance.new("Weld")
	weld.Parent = hrp
	weld.Part0 = hrp
	weld.Part1 = secondclone
	
	local scriptingeffects = require(game.ReplicatedStorage.Modules.Combat.combat_effects)
	scriptingeffects:SmallTrail(player,character,1.5)
	
	-- Emit particles
	for _, obj in ipairs(firstclone:GetDescendants()) do
		if obj:IsA("Attachment") then
			for _, emitter in ipairs(obj:GetChildren()) do
				if emitter:IsA("ParticleEmitter") then
					emitter.Enabled = false

					local delayTime = emitter:GetAttribute("EmitDelay") or 0
					local emitCount = emitter:GetAttribute("EmitCount") or 10
					
					task.delay(delayTime, function()
						wait(0.01)
						emitter:Emit(emitCount)
					end)
				end
			end
		end
	end


	-- Cleanup
	Debris:AddItem(firstclone, 2)




	-- ✨the small rocks✨ --
	
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")

	local tweenInfo = TweenInfo.new(
		3,
		Enum.EasingStyle.Circular,
		Enum.EasingDirection.Out
	)

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.IgnoreWater = true

	local rand = false
	local fixbug = false
	
	for i = 1,15 do
		wait(0.05)
		if not fixbug then
			task.wait(0.08)
		end
		fixbug = true
		task.delay(3,function()
			fixbug = false
		end)

		-- add the rocks
		local smallrocks = Instance.new("Part")
		smallrocks.Size = Vector3.new(0.6,0.6,0.6)
		smallrocks.Anchored = true
		smallrocks.CanCollide = false
		smallrocks.Parent = workspace

		
		local offset
		if not rand then
			offset = CFrame.new(2.5, 0, -3) *
				CFrame.Angles(
					math.rad(math.random(0,360)),
					math.rad(math.random(0,360)),
					math.rad(math.random(0,360))
				)
		else
			offset = CFrame.new(-2.5, 0, -3) *
				CFrame.Angles(
					math.rad(math.random(0,360)),
					math.rad(math.random(0,360)),
					math.rad(math.random(0,360))
				)
		end
		rand = not rand

		local startPos = (hrp.CFrame * offset).Position
		local rayOrigin = startPos + Vector3.new(0, 5, 0)
		local rayDirection = Vector3.new(0, -20, 0)

		local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)

		if result then
			smallrocks.Position = result.Position + result.Normal * 0.25 + Vector3.new(0,-0.25, 0)
			smallrocks.Orientation = Vector3.new(math.random(0,360), math.random(0,360), math.random(0,360))
			smallrocks.Material = result.Instance.Material
			smallrocks.Color = result.Instance.Color
		else
		
			smallrocks:Destroy()
			continue
		end


		task.delay(math.random(4,6), function()
			if smallrocks.Parent then
				local tween = TweenService:Create(
					smallrocks,
					tweenInfo,
					{Position = smallrocks.Position + Vector3.new(0, -1, 0)}
				)
				tween:Play()
				tween.Completed:Once(function()
					smallrocks:Destroy()
				end)
			end
		end)
	end
	
	
	--Debris:AddItem(secondclone)
	for _, obj in ipairs(secondclone:GetChildren()) do
		if obj:IsA("Attachment") then
			for _, emitter in ipairs(obj:GetChildren()) do
				if emitter:IsA("ParticleEmitter") then
					emitter.Enabled = false
				end
			end
		end
	task.delay(3,function()
			weld:Destroy()
			secondclone:Destroy()
	end)
	end
	
	
	
	thirdclone.CFrame = hrp.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, 0, 170 )
	
	
	-- Emit particles
	for _, obj in ipairs(thirdclone:GetDescendants()) do
		
		if obj:IsA("ParticleEmitter") then
			obj.Enabled = false

			local delayTime = obj:GetAttribute("EmitDelay") or 0
			local emitCount = obj:GetAttribute("EmitCount") or 10
			
			task.delay(delayTime, function()
				wait(0.01)
				obj:Emit(emitCount)
			end)
		end
		if obj:IsA("Attachment") then
			for _, emitter in ipairs(obj:GetChildren()) do
				if emitter:IsA("ParticleEmitter") then
					emitter.Enabled = false

					local delayTime = emitter:GetAttribute("EmitDelay") or 0
					local emitCount = emitter:GetAttribute("EmitCount") or 10
					
					task.delay(delayTime, function()
						wait(0.01)
						emitter:Emit(emitCount)
					end)
				end
			end
		end
	end
	local req = require(game.ServerScriptService.Combat.ATK_and_stun)
	
	req:ATKStart(character,0.8)
	scriptingeffects:Highlight(player,character,0.1,Color3.new(1, 1, 1),0.3)
	task.delay(0.3,function()
		dash_is_playing = false
	end)
	
	Debris:AddItem(thirdclone, 2)
	
end
return Manager
