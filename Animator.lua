--[[
	Cre's Animation Player
	Author: crephobia
	<(0_0<) <(0_0)> (>0_0)> KIRBY DANCE
]]


-----[ TYPES ]


type Character = Model & {
	HumanoidRootPart: Part,
	Humanoid: Humanoid,
}

export type Keyframe = {
	CFrames: {
		[string]: CFrame
	},
	Time: number,
	Markers: {string}?,
	Easing: {[string]: {
		EasingStyle: Enum.PoseEasingStyle,
		EasingDirection: Enum.PoseEasingDirection
	}}?
}

export type Animation = {
	Name: string,
	Module: ModuleScript,
	Properties: {
		Looped: boolean,
		Priority: number,
		TiltAngle: number?,
		[any]: any
	},
	_Keyframes: {Keyframe},
	_Markers: {[string]: number}?
}

export type AnimationTable = {
	Animation: Animation,
	Module: ModuleScript,
	Start: number,
	Time: number,
	Elapsed: number?,
	Priority: number,
	Looped: boolean,
	Speed: number,
	FadeOut: number,
	FadeEasingStyle: string?,
	FadeEasingDirection: string?
}

export type AnimationProperties = {
	Time: number?,
	Priority: number?,
	Looped: boolean?,
	Speed: number?,
	FadeOut: number?,
	FadeEasingStyle: string?,
	FadeEasingDirection: string?
}

type self = {
	Character: Character,
	Playing: Animation?,
	MarkerReached: RBXScriptSignal,
	_MarkerReachedBind: BindableEvent,
	_CurrentAnims: {[string]: AnimationTable},
	_LocalAnimStart: number,
	_FadeTime: number,
	_Motors: {[Motor6D]: string},
	_DefaultMotors: {[Motor6D]: CFrame},
	_StartCFrames: {[Motor6D]: CFrame},
	_CurrentCFrames: {[Motor6D]: CFrame},
	_EmptyKeyframe: Keyframe
}


-----[ VARIABLES ]

local TweenService = game:GetService("TweenService")
local AnimCache = {}

-----[ CLASS ]


local Animate = {}
Animate.__index = Animate

export type Animate = typeof(setmetatable({} :: self, Animate))

function Animate.new(char: Character): Animate
	local self = setmetatable({} :: self, Animate)

	self.Character = char
	self.Playing = nil
	
	local markerReached = Instance.new("BindableEvent")
	self.MarkerReached = markerReached.Event
	self._MarkerReachedBind = markerReached
	
	self._CurrentAnims = {}
	self._Motors = {}
	self._DefaultMotors = {}
	self._LocalAnimStart = 0
	self._FadeTime = 0
	
	self._EmptyKeyframe = {
		CFrames = {},
		Time = 0
	}
	
	for _, motor in char:GetDescendants() do
		if not motor:IsA("Motor6D") then continue end
		self._Motors[motor] = motor.Part0.Name.."_"..motor.Part1.Name
	end
	
	for motor, motorName in self._Motors do
		self._EmptyKeyframe.CFrames[motorName] = CFrame.identity
		self._DefaultMotors[motor] = motor.C0
	end 
	
	self._StartCFrames = table.clone(self._DefaultMotors)
	self._CurrentCFrames = table.clone(self._DefaultMotors)
	
	return self
end


-----[ PRIVATE FUNCTIONS ]


local function AssertAnimation(anim: ModuleScript)
	local cached = AnimCache[anim]
	if cached then return cached end
	
	local module = anim
	local anim: Animation = require(anim)
	assert(anim._Keyframes, "CrePlayer: Module is not an animation module.")
	
	AnimCache[module] = anim
	
	return anim
end

local function GetAnimLength(anim: Animation)
	return anim._Keyframes[#anim._Keyframes].Time
end

local function GetKeyframeData(self: Animate): {Motor6D: {Keyframe | number}}
	local animTable = self:GetPlaying()
	
	local keyframeData = {}
	local foundData = {}
	
	for motor, motorName in self._Motors do
		keyframeData[motor] = {self._EmptyKeyframe, self._EmptyKeyframe, 0}
		foundData[motor] = false
	end

	if animTable then
		local animTable: AnimationTable = animTable
		local anim: Animation = animTable.Animation
		
		if #anim._Keyframes == 1 then
			for motor, motorData in keyframeData do
				if not anim._Keyframes[1].CFrames[self._Motors[motor]] then continue end
				motorData[1] = anim._Keyframes[1]
				motorData[2] = anim._Keyframes[1]
				motorData[3] = 1
			end
		end
		
		local animLength = GetAnimLength(anim)
		local elapsed = animTable.Time % animLength
		
		if animTable.Time >= animLength and anim.Properties.Looped == false then
			animTable.Time = animLength
		end
		
		local found = 0
		for _, keyframe in anim._Keyframes do
			for motor, motorName in self._Motors do
				if foundData[motor] == true then continue end
				if not keyframe.CFrames[motorName] then continue end
				
				local motorData = keyframeData[motor]
				
				if keyframe.Time < elapsed then
					motorData[2] = keyframe
					continue
				end
				
				motorData[1] = keyframe
				local lastKeyframe = motorData[2]
				motorData[3] = (elapsed - lastKeyframe.Time) / (keyframe.Time - lastKeyframe.Time)
				
				if motorData[3] ~= motorData[3] then
					motorData[3] = 0
				end
				
				if lastKeyframe.Easing then
					local easing = lastKeyframe.Easing[motorName]
					if easing then
						if easing == "Constant" then
							motorData[3] = 0
						else
							local eDirection, eStyle = table.unpack(string.split(easing, "_"))
							eDirection = Enum.EasingDirection[eDirection] or Enum.EasingDirection.Out
							eStyle = Enum.EasingStyle[eStyle] or Enum.EasingStyle.Quad
							motorData[3] = TweenService:GetValue(motorData[3], eStyle, eDirection)
						end
					end
				end
				
				foundData[motor] = true
				found += 1
			end
		end
	end
	
	return keyframeData
end

local function GetAnimTable(self: Animate, anim: Animation): AnimationTable?
	return self._CurrentAnims[anim.Name]
end


-----[ METHODS ]


function Animate.GetPlaying(self: Animate): AnimationTable?
	local playing = nil
	for _, animTable in self._CurrentAnims do
		if playing == nil then 
			playing = animTable
		elseif animTable.Priority > playing.Priority then
			playing = animTable
		elseif animTable.Start > playing.Start then
			playing = animTable
		end
	end
	
	return playing
end

function Animate.Play(self: Animate, anim: ModuleScript, fade: number?, properties: AnimationProperties)
	properties = properties or {}
	
	local module = anim
	local anim: Animation = AssertAnimation(anim)
	
	local currentAnimTable = GetAnimTable(self, anim)
	if currentAnimTable then
		for property, value in properties do
			currentAnimTable[property] = value 
		end
	else
		local animTable = {
			Animation = anim,
			Module = module,
			Start = os.clock(),
			Time = properties.Time or 0,
			Priority = properties.Priority or anim.Properties.Priority or 2,
			Looped = anim.Properties.Looped or false,
			Speed = properties.Speed or 1,
			FadeOut = properties.FadeOut or .1,
			FadeEasingStyle = properties.FadeEasingStyle,
			FadeEasingDirection = properties.FadeEasingDirection
		}

		self._FadeTime = fade or .1

		self._CurrentAnims[anim.Name] = animTable
	end
end

function Animate.Stop(self: Animate, anim: ModuleScript | Animation, fadeTime: number?)
	self._CurrentAnims[anim.Name] = nil
	self._FadeTime = fadeTime or .2
end

local procMarkers = {}
local lastElapsed = {}

function Animate.CheckMarkers(self: Animate)
	for _, playing in self._CurrentAnims do
		if playing.Animation._Markers then
			procMarkers[playing.Module] = procMarkers[playing.Module] or {}
			
			if lastElapsed[playing.Module] and lastElapsed[playing.Module] > playing.Elapsed then
				for marker, markerTime in playing.Animation._Markers do
					if not table.find(procMarkers[playing.Module], marker) then
						self._MarkerReachedBind:Fire(marker, playing.Animation.Name)
					end
				end
				table.clear(procMarkers[playing.Module])
			end
			
			for marker, markerTime in playing.Animation._Markers do
				if table.find(procMarkers[playing.Module], marker) then continue end
				if markerTime < playing.Time then
					self._MarkerReachedBind:Fire(marker, playing.Animation.Name)
					table.insert(procMarkers[playing.Module], marker)
				end
			end
			
			lastElapsed[playing.Module] = playing.Elapsed
		end
	end
end

function Animate.Step(self: Animate, elapsed: number)
	for _, animation in self._CurrentAnims do
		animation.Time += elapsed * animation.Speed
		animation.Elapsed = animation.Time %  GetAnimLength(animation.Animation)
		
		if animation.Time >= GetAnimLength(animation.Animation) and animation.Looped == false then
			self:Stop(animation.Animation, animation.FadeOut)
		end
	end
	
	self:CheckMarkers()
	
	local playing = self:GetPlaying()
	local keyframeData = GetKeyframeData(self)
	
	if playing ~= self.Playing then
		self._LocalAnimStart = os.clock()
		self._StartCFrames = table.clone(self._CurrentCFrames)
	end
	self.Playing = playing
	
	local fadeLerp = 1
	if self._FadeTime ~= 0 then
		local elapsed = os.clock() - self._LocalAnimStart
		fadeLerp = math.clamp(elapsed/self._FadeTime, 0, 1)
		if fadeLerp == 1 then
			self._FadeTime = 0
		end
	end
	
	if fadeLerp < 1 and playing and playing.FadeEasingStyle then
		local eStyle = Enum.EasingStyle[playing.FadeEasingStyle] or Enum.EasingStyle.Quad
		local eDirection = Enum.EasingDirection[playing.FadeEasingDirection] or Enum.EasingDirection.Out
		fadeLerp = TweenService:GetValue(fadeLerp, eStyle, eDirection)
	end
	
	for motor, motorName in self._Motors do
		local animCFrame = CFrame.identity
		local currentKeyframe = keyframeData[motor][1]
		local lastKeyframe = keyframeData[motor][2]
		local lerp = keyframeData[motor][3]
		
		local animCFrame = self._DefaultMotors[motor] * lastKeyframe.CFrames[motorName]:Lerp(currentKeyframe.CFrames[motorName], lerp)
		
		if fadeLerp ~= 1 then
			motor.C0 = self._StartCFrames[motor]:Lerp(animCFrame, fadeLerp)
		else
			motor.C0 = animCFrame
		end
		
		self._CurrentCFrames[motor] = motor.C0
	end
end

function Animate.IsPlaying(self: Animate, anim: ModuleScript)
	local anim = require(anim)
	for _, animTable in self._CurrentAnims do
		if anim == animTable.Animation then
			return true
		end
	end
	return false
end

function Animate.ClearAnimations(self: Animate, fadeOut: number)
	for _, animTable in self._CurrentAnims do
		self:Stop(animTable.Animation, fadeOut or 0)
	end
	self._FadeTime = fadeOut or 0
end

return Animate
