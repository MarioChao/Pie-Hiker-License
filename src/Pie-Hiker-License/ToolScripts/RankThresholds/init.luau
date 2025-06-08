--!strict
-- Rank Thresholds Module Script


---------- Main module ----------

local RunService = game:GetService("RunService")

-- If not a model
if script.Parent.Parent then
	if RunService:IsServer() then
		-- For dynamic data loading, add a line that requires the asset id 106825359403933
	else
		local RankThreshold_RemoteFunction = script:WaitForChild("RankThreshold_RemoteFunction")
		return RankThreshold_RemoteFunction:InvokeServer("Get Rank Thresholds")
	end
end


---------- Module ----------

local RankThresholds = {}


---------- Types ----------

export type MinBadgeCondition = {
	badgeTier: {number},
	minimumBadges: number,
}

export type RankTreshold = {
	rankTitle: string,
	conditions: {MinBadgeCondition}
}


---------- Variables ----------

local badgeTierIds = require(script["pie-hiking-tiers"]["tiered-badges"])

local rankThresholds: {RankTreshold} = require(script["pie-hiking-tiers"]["tiered-ranks"])

table.freeze(badgeTierIds)
table.freeze(rankThresholds)


---------- Module variables ----------

RankThresholds.badgeTierIds = badgeTierIds
RankThresholds.rankThresholds = rankThresholds


---------- Return module ----------

return RankThresholds

