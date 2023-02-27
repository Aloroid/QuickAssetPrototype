local RunService = game:GetService("RunService")
--[[
	Starts all the modules and such
	
]]

local Packages = script.Parent.Packages
local Services = script.Parent.Services

local CubeCat = require(Packages.CubeCat)

-- Roblox cannot load id's from assets imported in run-time
if RunService:IsRunning() then return end

CubeCat.AddServices(Services:GetChildren())
CubeCat.Start()