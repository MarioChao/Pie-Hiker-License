--!strict
-- Player Scripts Set Up Script


---------- Services ----------

local Players = game:GetService("Players")


---------- Instances ----------

local LocalPlayer = Players.LocalPlayer

local ToolPlayerScripts = script.Parent.PlayerScripts


---------- Local functions ----------

local function setUpPlayerScripts()
	local PlayerScripts = LocalPlayer.PlayerScripts
	for _, object in ToolPlayerScripts:GetChildren() do
		if not PlayerScripts:FindFirstChild(object.Name) then
			local newObject = object:Clone()
			newObject.Parent = PlayerScripts
		end
	end
end


---------- Calling / connecting functions ----------

setUpPlayerScripts()
