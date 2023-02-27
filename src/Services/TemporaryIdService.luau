--[[
	TemporaryIdService stores the Id's.
]]

local StudioService = game:GetService("StudioService")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Plugin = script.Parent.Parent
local Services = Plugin.Services
local Packages = Plugin.Packages

local CubeCat = require(Packages.CubeCat)

local FindAndReplaceService = require(Services.FindAndReplaceService)

local Permissions = CubeCat.Permissions

local TemporaryIdService = CubeCat.CreateService({
	Name = "TemporaryIdService",
	Public = {},
	Ids = {}
})

local ALLOWED_FILE_TYPES = {
	Both = {"png", "mp3", "ogg", "mesh"},
	Image = {"png", "tga", "bmp"},
	Sound = {"mp3", "ogg"},
	Mesh = {"mesh"} -- Roblox uses their own proprietary mesh format.
	
}

TemporaryIdService.Extensions = ALLOWED_FILE_TYPES

function TemporaryIdService:Init()
	
	Permissions.new("createTemporaryId", "Allow Request To Load Files", "This allows the user plugin to prompt the user a file they want to upload.")
	
end

local idChanged = false
function TemporaryIdService:IsChanged()
	if idChanged == true then
		idChanged = false
		return true
	end
	
	return false
end

function TemporaryIdService:RequestId(type: "Image" | "Sound" | "Mesh" | "Both", key: string)
	
	local file: File = StudioService:PromptImportFile(ALLOWED_FILE_TYPES[type])
	if file == nil then return end
	
	return TemporaryIdService:AddId({
		Id = file:GetTemporaryId(),
		Name = file.Name,
		Key = key,
	})
	
end

function TemporaryIdService:AddId(fileData)
	
	local key = fileData.Key
	
	local previousFile = TemporaryIdService.Ids[key]
	TemporaryIdService.Ids[key] = fileData
	
	idChanged = true
	
	plugin:SetSetting("TemporaryFileIds", TemporaryIdService.Ids)
	
	if previousFile == nil then return fileData.Id end
	local oldId = previousFile.Id
	local newId = fileData.Id
	
	FindAndReplaceService:Replace(oldId, newId)
	
	return newId
	
end

function TemporaryIdService:Remove(key: string)
	idChanged = true
	TemporaryIdService.Ids[key] = nil
	
end

return TemporaryIdService