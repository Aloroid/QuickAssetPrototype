--[[
	This service keeps track of all the objects that are a certain class.
	We'll iterate through all these objects later to determine if they need to
	be changed.
	
]]

local Plugin = script.Parent.Parent

local Packages = Plugin.Packages

local CubeCat = require(Packages.CubeCat)

local ObjectTrackerService = CubeCat.CreateService({
	Name = "ObjectTrackerService",
	Public = {},
	Tracked = {}
})

local TYPES = {
	
	["ImageLabel"] = "Image",
	["ImageButton"] = "Image",
	["ImageHandleAdornment"] = "Image",
	["Decal"] = "Texture",
	
	["Sound"] = "SoundId",
	
	["BaseScript"] = "Script"
	
}

local TRACKED_SERVICES = {
	
	"Workspace",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
	"SoundService"
	
}

function ObjectTrackerService:Init()
	
	debug.profilebegin("Track Services")
	for _, serviceName in TRACKED_SERVICES do
		
		local service = game:GetService(serviceName)
		
		service.DescendantAdded:Connect(function(instance)
			ObjectTrackerService:TrackInstance(instance)
		end)
		
		-- Go through all descendants
		for _, instance in service:GetDescendants() do
			ObjectTrackerService:TrackInstance(instance)
			
		end
		
	end
	debug.profileend()
	
end


--[[
	This function will add the instance to the list of tracked instances which
	will be went through to see
	
]]
function ObjectTrackerService:TrackInstance(instance: Instance)
	
	local type
	
	-- Find the type corresponding
	for className, possibleType in TYPES do
		if instance:IsA(className) then
			type = possibleType
			break
		end
	end
	
	if not type then return end
	
	ObjectTrackerService.Tracked[instance] = type
	
	instance.AncestryChanged:Connect(function(_, parent)
		if parent ~= nil then return end
		ObjectTrackerService.Tracked[instance] = nil
	end)
	
end


return ObjectTrackerService