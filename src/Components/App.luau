local Plugin = script.Parent.Parent
local Services = Plugin.Services
local Packages = Plugin.Packages
local Components = Plugin.Components

local Fusion = require(Packages.Fusion)
local CubeCat = require(Packages.CubeCat)

local TemporaryIdService = require(Services.TemporaryIdService)

local HorizontalRow = require(Components.HorizontalRow)

local Background = CubeCat.Components.Background
local ScrollingFrame = CubeCat.Components.ScrollingFrame
local Pane = CubeCat.Components.Pane
local Text = CubeCat.Components.Text
local TextInput = CubeCat.Components.TextInput
local Padding = CubeCat.Components.Padding
local Image = CubeCat.Components.Image
local Button = CubeCat.Components.Button

local Runtime = CubeCat.Runtime

local New = Fusion.New
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local ForPairs = Fusion.ForPairs
local Children = Fusion.Children

local Theme = CubeCat.Util.Theme
local stripProps = CubeCat.Util.stripProps

type CanBeState<T> = Fusion.CanBeState<T>
export type App = {
	[any]: any
}

local COMPONENT_ONLY_PROPERTIES = {
	
	
}

local function App(props: App)
	
	local f = true
	local ids = Runtime(function()
		local oldF = f
		f = false
		return TemporaryIdService.Ids, oldF or TemporaryIdService:IsChanged()
		
	end)
	
	local currentText = Value("")
	
	local App = ScrollingFrame {
		
		[Children] = {
			
			ForPairs(ids, function(key, file)
				
				local hovering = Value(false)
				
				return key, Pane {
					
					[Children] = {
						
						Background {
							
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							
							LayoutOrder = 2,
							
							NoPadding = true,
							NoList = true,
							
							[Children] = {
								Text {
									Size = UDim2.new(1, -24, 0, 0),
									AutomaticSize = Enum.AutomaticSize.Y,
									
									Text = key,
									TextTruncate = Enum.TextTruncate.AtEnd,
									TextXAlignment = Enum.TextXAlignment.Left
								},
								
								Button {
									Position = UDim2.fromScale(1, .5),
									AnchorPoint = Vector2.new(1, .5),
									
									NoText = true,
									NoPadding = true,
									
									Visible = hovering,
									
									[Children] = {
										
										Image {
										
											Size = UDim2.fromOffset(16, 16),
											Image = "rbxasset://textures/ui/InspectMenu/x.png",
											
										},
										
										Padding {
											Padding = 4
										}
										
									},
									
									[OnEvent "Activated"] = function()
										TemporaryIdService:Remove(key)
									end
									
								}
								
								
							},
							
							[OnEvent "MouseEnter"] = function()
								hovering:set(true)
							end,
							
							[OnEvent "MouseLeave"] = function()
								hovering:set(false)
							end,
							
						},
						
						New "Frame" {
							Size = UDim2.new(1, 0, 0, 1),
							
							BackgroundTransparency = 1,
							
							[Children] = New "Frame" {
								Size = UDim2.new(1, 20, 0, 1),
								Position = UDim2.fromScale(0.5, 0),
								AnchorPoint = Vector2.new(0.5, 0),
								
								BackgroundColor3 = Theme(Enum.StudioStyleGuideColor.Border)
								
							}
						},
						
						Text {Text = `Current File: {file.Name}`},
						
						HorizontalRow {
							[Children] = {
								TextInput {
									Size = UDim2.new(1, -92, 0, 30),
									
									Disabled = true,
									Text = file.Id
								},
								Button {
									Text = "Change File",
									[OnEvent "Activated"] = function()
										TemporaryIdService:RequestId("Both", key)
									end
								}
							}
						},
						
						
					}
				}
				
			end, Fusion.cleanup),
			
			TextInput {
				
				Size = UDim2.new(1, 0, 0, 0),
				PlaceholderText = "Add New Temporary File",
				Text = currentText,
				ErrorLocation = "Bottom",
				
				FocusLost = function(enterPressed)
					if enterPressed == false then return end
					TemporaryIdService:RequestId("Both", currentText:get())
					currentText:set("")
				end,
				
				Validator = function(text: string)
					
					if TemporaryIdService.Ids[text] then
						return false, `"{text}" already exists!`
					end
					
					return true
					
				end
				
			}
			
		}
		
	}
	
	
	return Fusion.Hydrate(App)(stripProps(props, COMPONENT_ONLY_PROPERTIES))
	
end

return App