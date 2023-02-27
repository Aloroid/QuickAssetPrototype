--[[
	This service keeps track of all the files that are currently loaded in the
	session and adds them back into Studio if we are still running in the same
	session.
	
	Note: Roblox can make these fail for no reason, even if they are loaded.
		  This makes them persisting completely random.
	
]]

local ContentProvider = game:GetService("ContentProvider")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Plugin = script.Parent.Parent
local Services = Plugin.Services
local Packages = Plugin.Packages

local CubeCat = require(Packages.CubeCat)

local TemporaryIdService = require(Services.TemporaryIdService)

local FilePreloadService = CubeCat.CreateService({
	Name = "FilePreloadService",
	Public = {}
})

function FilePreloadService:Init()
	
	-- Delayed for higher success?
	task.delay(1, function()
		
		local temporaryFileIds = plugin:GetSetting("TemporaryFileIds") :: {[string]: {Id: string, Key: string, Name: string}}
		if temporaryFileIds == nil then return end
		
		local assets = {}
		local set = {}
		
		for _, file in temporaryFileIds do
			local object = FilePreloadService:CreateAsset(file)
			
			if object == nil then continue end
			table.insert(assets, object)
			set[file.Id] = file
			
		end
		
		ContentProvider:PreloadAsync(assets, function(id: string, fetchStatus)
			
			if fetchStatus == Enum.AssetFetchStatus.Failure then return end
			TemporaryIdService:AddId(set[id])
			
		end)
		
		plugin:SetSetting("TemporaryFileIds", TemporaryIdService.Ids)
	end)
	
end

function FilePreloadService:CreateAsset(file)
	
	local name = file.Name
	local splitted = string.split(name, ".")
	local extension = splitted[#splitted]
	
	local asset
	
	if table.find(TemporaryIdService.Extensions.Image, extension) then
		asset = Instance.new("Texture")
		asset.Texture = file.Id
		
	elseif table.find(TemporaryIdService.Extensions.Sound, extension) then
		asset = Instance.new("Sound")
		asset.SoundId = file.Id
		
	elseif table.find(TemporaryIdService.Extensions.Mesh, extension) then
		asset = Instance.new("SpecialMesh")
		asset.MeshId = file.Id
		
	end
	
	return asset
	
end


return FilePreloadService