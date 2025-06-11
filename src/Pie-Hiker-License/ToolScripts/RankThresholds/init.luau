--!strict
-- Rank Thresholds Module Script


---------- Main module ----------

local RunService = game:GetService("RunService")

-- If not a model
if script.Parent.Parent then
	if RunService:IsServer() then
		-- For dynamic data loading, add a line that `requires` the asset id 106825359403933 and `returns` the result
	else
		local RankThreshold_RemoteFunction = script:WaitForChild("RankThreshold_RemoteFunction")
		return RankThreshold_RemoteFunction:InvokeServer("Get Rank Thresholds")
	end
end


---------- Module ----------

local RankThresholds = {}


---------- Types ----------

export type BadgeTierInfo = {
	badgeId: number,
	tier: number,
}

export type MinBadgeCondition = {
	badgeTier: number,
	minimumBadges: number,
}

export type RankTreshold = {
	rankTitle: string,
	conditions: {MinBadgeCondition},
}


---------- Variables ----------

local badgeTierInfos: {BadgeTierInfo} = require(script["pie-hiking-tiers"]["tiered-badges"])

local rankThresholds: {RankTreshold} = require(script["pie-hiking-tiers"]["tiered-ranks"])

table.freeze(badgeTierInfos)
table.freeze(rankThresholds)


local badgeTierIds: {{number}}

local rankPriority: {[string]: number}


---------- Set up functions ----------

local function setUpBadgeTierIds()
	badgeTierIds = {}
	for i = 1, 10 do
		table.insert(badgeTierIds, {})
	end

	for _, badgeInfo in badgeTierInfos do
		local badgeId = badgeInfo.badgeId
		local tier = badgeInfo.tier

		while tier > #badgeTierIds do
			table.insert(badgeTierIds, {})
		end
		table.insert(badgeTierIds[tier], badgeId)
	end
end

local function setUpRankPriority()
	rankPriority = {}
	local maxIndex = #rankThresholds
	for index, rankThreshold in rankThresholds do
		rankPriority[rankThreshold.rankTitle] = maxIndex - index
	end
end


---------- Calling / connecting functions ----------

setUpBadgeTierIds()
table.freeze(badgeTierIds)

setUpRankPriority()
table.freeze(rankPriority)


---------- Module variables ----------

RankThresholds.badgeTierInfos = badgeTierInfos
RankThresholds.badgeTierIds = badgeTierIds

RankThresholds.rankThresholds = rankThresholds
RankThresholds.rankPriority = rankPriority


---------- Return module ----------

return RankThresholds

