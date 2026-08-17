--!strict

-- Player Scripts Set Up Script


---------- Services ----------

local Players = game:GetService("Players")


---------- Constants ----------

local Constants = {}

Constants.localPlayer = Players.LocalPlayer
Constants.playerScripts = Constants.localPlayer.PlayerScripts

Constants.toolPlayerScripts = script.Parent:WaitForChild("PlayerScripts")


---------- Local functions ----------

local setUpPlayerScriptInstance
local setUpPlayerScripts


----- Player scripts -----

setUpPlayerScriptInstance = function(object: Instance)
	if not Constants.playerScripts:FindFirstChild(object.Name) then
		local newObject = object:Clone()
		newObject.Parent = Constants.playerScripts
	end
end

setUpPlayerScripts = function()
	task.defer(function()
		for _, object in Constants.toolPlayerScripts:GetChildren() do
			task.defer(setUpPlayerScriptInstance, object)
		end
	end)
	Constants.toolPlayerScripts.ChildAdded:Connect(setUpPlayerScriptInstance)
end


----- Main -----

local function main()
	setUpPlayerScripts()
end


---------- Calling function ----------

main()
