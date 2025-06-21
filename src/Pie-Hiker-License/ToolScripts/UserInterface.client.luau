--!strict
-- User Interface Script


---------- Tool ----------

local Tool = script.Parent.Parent


---------- Services ----------

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")


---------- Imports ----------

local LocalPlayer = Players.LocalPlayer
local PieHikerLicense_PlayerScripts = LocalPlayer.PlayerScripts:WaitForChild("PieHikerLicense_PlayerScripts")

local CachedBadgeCheck = require(PieHikerLicense_PlayerScripts.CachedBadgeCheck or script.Parent.PlayerScripts.PieHikerLicense_PlayerScripts.CachedBadgeCheck)
local RankThresholds = require(script.Parent:WaitForChild("RankThresholds"))


---------- Instances ----------

local ToolAssets = Tool:WaitForChild("ToolAssets")
local Default_PieHikerLicense_ScreenGui = ToolAssets:WaitForChild("PieHikerLicense_ScreenGui")

local PieHikerLicense_ScreenGui: typeof(Default_PieHikerLicense_ScreenGui)


---------- Variables  ----------

local badgeTierIds = RankThresholds.badgeTierIds
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

local function getRank()
	for _, rankThreshold in rankThresholds do
		-- Check conditions
		local conditionMet = true
		for _, condition in rankThreshold.conditions do
			-- Validate minimum badges
			if countBadges(LocalPlayer, badgeTierIds[condition.badgeTier]) < condition.minimumBadges then
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


---------- Local functions ----------

local function setUpScreenGui()
	-- Initialize screen gui
	PieHikerLicense_ScreenGui = LocalPlayer.PlayerGui:FindFirstChild("PieHikerLicense_ScreenGui")
	if not PieHikerLicense_ScreenGui then
		PieHikerLicense_ScreenGui = Default_PieHikerLicense_ScreenGui:Clone()
		PieHikerLicense_ScreenGui.Parent = LocalPlayer.PlayerGui
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
	local thumbnailContent, thumbnailIsReady = getPlayerThumbnail(LocalPlayer)
	if thumbnailIsReady then
		(PieHikerLicense_ScreenGui.LicenseFrame.Avatar_ImageLabel :: ImageLabel).Image = thumbnailContent
	end

	-- Get details
	local DetailsFrame = PieHikerLicense_ScreenGui.LicenseFrame.DetailsFrame

	-- Set rank
	DetailsFrame.RankFrame.Rank_TextLabel.Text = getRank()

	-- Set info
	DetailsFrame.InfoFrame.Id_TextLabel.Text = LocalPlayer.UserId


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
		if hasAllBadges(LocalPlayer,badgeIds) then
			table.insert(achievements, `All ({#badgeIds}) tier {tier}.`)
		else
			local count = countBadges(LocalPlayer, badgeIds)
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
	PieHikerLicense_ScreenGui.LicenseFrame.Signature_TextLabel.Text = LocalPlayer.Name
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

Tool.Equipped:Connect(onToolEquipped)
Tool.Unequipped:Connect(onToolUnequipped)
