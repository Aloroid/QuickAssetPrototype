local Plugin = script.Parent.Parent
local Services = Plugin.Services
local Packages = Plugin.Packages

local CubeCat = require(Packages.CubeCat)

local ObjectTrackerService = require(Services.ObjectTrackerService)

local FindAndReplaceService = CubeCat.CreateService({
	Name = "FindAndReplaceService",
	Public = {}
})

function FindAndReplaceService:Init()
	
	
end

function FindAndReplaceService:ForScript(changing: ModuleScript & Script & LocalScript, oldId: string, newId: string)
	
	local pattern = `{oldId}[^%d]`
	
	changing.Source = string.gsub(
		changing.Source,
		pattern,
		function(match)
			local replacement = `{newId}{string.sub(match, #match)}`
			return replacement
		end
	)
	
end

function FindAndReplaceService:Replace(oldId: string, newId: string)
	
	for instance, type in ObjectTrackerService.Tracked do
		
		if type == "Script" then
			FindAndReplaceService:ForScript(instance, oldId, newId)
			continue
		end
		
		if instance[type] == oldId then
			instance[type] = newId
		end
		
	end
	
end

return FindAndReplaceService