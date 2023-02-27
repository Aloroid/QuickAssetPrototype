local Plugin = script.Parent.Parent
local Packages = Plugin.Packages

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local Background = CubeCat.Components.Background

type CanBeState<T> = Fusion.CanBeState<T>
export type HorizontalRow = {
	Position: CanBeState<UDim2>?,
	Size: CanBeState<UDim2>?,
	AnchorPoint: CanBeState<Vector2>?,
	
	

	[any]: any
}

local function HorizontalRow(props: HorizontalRow)
	
	local properties = {
		
		Name = "Row",
		
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		
		NoPadding = true
		
	}
	
	-- Copy the properties
	
	for k,v in props do
		properties[k] = v
	end
	
	return Background(properties)
	
end

return HorizontalRow