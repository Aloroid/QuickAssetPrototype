--[[
	TemporaryIdService stores the Id's.
]]

local StudioService = game:GetService("StudioService")

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
	Both = {"png", "mp3", "ogg"},
	Image = {"png", "tga", "bmp"},
	Sound = {"mp3", "ogg"},
	--Video = {"mp4", "mov", "webm", "mkv"} // Video currently cannot be played inside Roblox when loaded from a rbxtemp://
}

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

function TemporaryIdService:RequestId(type: "Image" | "Sound", key: string)
	
	local file: File = StudioService:PromptImportFile(ALLOWED_FILE_TYPES[type])
	if file == nil then return end
	
	local previousFile = TemporaryIdService.Ids[key]
	TemporaryIdService.Ids[key] = file
	
	idChanged = true
	
	if previousFile == nil then return file:GetTemporaryId() end
	local oldId = previousFile:GetTemporaryId()
	local newId = file:GetTemporaryId()
	
	FindAndReplaceService:Replace(oldId, newId)
	
	return newId
	
end

function TemporaryIdService:Remove(key: string)
	idChanged = true
	TemporaryIdService.Ids[key] = nil
	
end

return TemporaryIdService