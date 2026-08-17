--!strict

-- User Interface Script


---------- Services ----------

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")


---------- Imports ----------

local _LocalPlayer = Players.LocalPlayer
local _PieHikerLicense_PlayerScripts = _LocalPlayer.PlayerScripts:WaitForChild("PieHikerLicense_PlayerScripts")

local _Tool_PlayerScripts = script.Parent:WaitForChild("PlayerScripts")
local _Tool_PieHikerLicense_PlayerScripts = _Tool_PlayerScripts:WaitForChild("PieHikerLicense_PlayerScripts")
local _Tool_CachedBadgeCheck = _Tool_PieHikerLicense_PlayerScripts:WaitForChild("CachedBadgeCheck")
local CachedBadgeCheck = require(_PieHikerLicense_PlayerScripts:WaitForChild("CachedBadgeCheck") :: typeof(_Tool_CachedBadgeCheck))
local RankThresholds = require(script.Parent:WaitForChild("RankThresholds"))


---------- Constants ----------

local Constants = {}

Constants.localPlayer = _LocalPlayer

Constants.tool = script.Parent.Parent
do
	local toolAssets = Constants.tool:WaitForChild("ToolAssets")
	Constants.default_PieHikerLicense_ScreenGui = toolAssets:WaitForChild("PieHikerLicense_ScreenGui")
end

local PieHikerLicense_ScreenGui: typeof(Constants.default_PieHikerLicense_ScreenGui)


---------- Variables  ----------

local badgeTierIds = RankThresholds.badgeTierIds :: {{number}}
local rankThresholds = RankThresholds.rankThresholds

local setUpUserInterface_throttle = false


---------- Helper functions ----------

local function getPlayerThumbnail(player: Player): (string, boolean)
	return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
end

local function hasAllBadges(player: Player, badgeIds: {number})
	local checkResult = CachedBadgeCheck.userHasBadges(player.UserId, badgeIds)
	for _, badgeId in badgeIds do
		if not checkResult[badgeId] then
			return false
		end
	end
	return true
end

local function countBadges(player: Player, badgeIds: {number})
	local checkResult = CachedBadgeCheck.userHasBadges(player.UserId, badgeIds)
	local count = 0
	for _, isAwarded in checkResult do
		if isAwarded then
			count += 1
		end
	end
	return count
end

local function getRank(player: Player)
	for _, rankThreshold in rankThresholds do
		-- Check conditions
		local conditionMet = true
		for _, condition in rankThreshold.conditions do
			-- Validate minimum badges
			if countBadges(player, badgeTierIds[condition.badgeTier]) < condition.minimumBadges then
				conditionMet = false
				break
			end
		end

		-- Validate condition met
		if not conditionMet then
			continue
		end

		-- Return title
		return rankThreshold.rankTitle
	end
	return "???"
end

local function checkAllBadges(player: Player)
	local allBadgeIds = {}
	for _, badgeIds in badgeTierIds do
		for _, badgeId in badgeIds do
			table.insert(allBadgeIds, badgeId)
		end
	end
	CachedBadgeCheck.userHasBadges(player.UserId, allBadgeIds)
end


---------- Local functions ----------

local function setUpScreenGui()
	-- Initialize screen gui
	PieHikerLicense_ScreenGui = Constants.localPlayer.PlayerGui:FindFirstChild("PieHikerLicense_ScreenGui")
	if not PieHikerLicense_ScreenGui then
		PieHikerLicense_ScreenGui = Constants.default_PieHikerLicense_ScreenGui:Clone()
		PieHikerLicense_ScreenGui.Parent = Constants.localPlayer.PlayerGui
	end

	-- Enable screen gui
	PieHikerLicense_ScreenGui.Enabled = true
end

local function setUpUserInterface()
	-- Validate screen gui
	if not PieHikerLicense_ScreenGui then
		return
	end

	-- Set avatar image
	local thumbnailContent, thumbnailIsReady = getPlayerThumbnail(Constants.localPlayer)
	if thumbnailIsReady then
		(PieHikerLicense_ScreenGui.LicenseFrame.Avatar_ImageLabel :: ImageLabel).Image = thumbnailContent
	end

	-- Check all badges
	checkAllBadges(Constants.localPlayer)

	-- Get details
	local DetailsFrame = PieHikerLicense_ScreenGui.LicenseFrame.DetailsFrame

	-- Set rank
	DetailsFrame.RankFrame.Rank_TextLabel.Text = getRank(Constants.localPlayer)

	-- Set info
	DetailsFrame.InfoFrame.Id_TextLabel.Text = Constants.localPlayer.UserId


	---------- Achievements ----------

	-- Get template label
	local List_ScrollingFrame = DetailsFrame.AchievementsFrame.List_ScrollingFrame
	local Template_TextLabel = List_ScrollingFrame.Template_TextLabel
	Template_TextLabel.Visible = false

	-- Get new achievements
	local achievements: {string} = {}
	for tier, badgeIds in badgeTierIds do
		-- Validate non-empty
		if #badgeIds == 0 then
			continue
		end

		-- Check badges
		if hasAllBadges(Constants.localPlayer, badgeIds) then
			table.insert(achievements, `All ({#badgeIds}) tier {tier}.`)
		else
			local count = countBadges(Constants.localPlayer, badgeIds)
			table.insert(achievements, `({count}) tier {tier}.`)
		end
	end

	-- Clear old labels
	for _, object in List_ScrollingFrame:GetChildren() do
		if object:IsA("TextLabel") and object ~= Template_TextLabel then
			Debris:AddItem(object, 0)
		end
	end

	-- Set new labels
	for _, achievementText in achievements do
		local label = Template_TextLabel:Clone()
		label.Name = "Achievement_TextLabel"
		label.Text = achievementText
		label.Visible = true
		label.Parent = List_ScrollingFrame
	end


	-- Signature
	PieHikerLicense_ScreenGui.LicenseFrame.Signature_TextLabel.Text = Constants.localPlayer.Name
end


---------- Event functions ----------

local function onToolEquipped(mouse: Mouse)
	setUpScreenGui()

	if not setUpUserInterface_throttle then
		-- Throttle
		setUpUserInterface_throttle = true

		-- Function
		setUpUserInterface()

		-- Revert throttle
		task.delay(1, function()
			setUpUserInterface_throttle = false
		end)
	end

end

local function onToolUnequipped()
	if PieHikerLicense_ScreenGui then
		PieHikerLicense_ScreenGui.Enabled = false
	end
end


---------- Calling / connecting functions ----------

Constants.tool.Equipped:Connect(onToolEquipped)
Constants.tool.Unequipped:Connect(onToolUnequipped)
