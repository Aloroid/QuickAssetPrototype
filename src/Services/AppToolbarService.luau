--[[
	AppToolbarService creates a Plugin Toolbar and Plugin Button which are used
	to open a DockWidgetPluginGui to display the interface in which will show
	the players the current State from StateService.

]]

local RunService = game:GetService("RunService")

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local Plugin = script.Parent.Parent
local Packages = Plugin.Packages
local Components = Plugin.Components

local CubeCat = require(Packages.CubeCat)

local App = require(Components.App)

local AppToolbarService = CubeCat.CreateService({
	Name = "AppToolbarService",
	Public = {}
})

local toolbar
function AppToolbarService:GetToolbar()
	if toolbar then return toolbar end
	toolbar = plugin:CreateToolbar("QuickProto")
	
	return toolbar
end

local widget
function AppToolbarService:GetWidget()
	if widget then return widget end
	
	local guiInfo = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Float,
		true,
		false,
		256+16,
		400,
		256+32,
		200
	)
	widget = plugin:CreateDockWidgetPluginGui("QuickProto", guiInfo)
	widget.Title = "Quick Asset Prototype"
	
	return widget
	
end

function AppToolbarService:Init()
	
	if RunService:IsRunning() then return end
	--if true then return end -- currently not used
	
	local toolbar = AppToolbarService:GetToolbar()
	local button = toolbar:CreateButton(
		"New Item",
		"Opens the widget for viewing all assets",
		"",
		"Open QuickProto"
	)
	
	local widget = AppToolbarService:GetWidget()
	local enabled = widget.Enabled
	
	local function swapState()
		enabled = not enabled
		button:SetActive(enabled)
		widget.Enabled = enabled		
	end
	
	button.Click:Connect(swapState)
	widget:BindToClose(swapState)
	
	App {
		Parent = widget
	}
	
	task.wait()
	button:SetActive(widget.Enabled)
	
end

return AppToolbarService