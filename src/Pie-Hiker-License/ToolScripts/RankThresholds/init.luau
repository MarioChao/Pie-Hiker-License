--!strict

-- Rank Thresholds


---------- Main module ----------

local RunService = game:GetService("RunService")

-- If not a model
if script.Parent.Parent then
	if RunService:IsServer() then
		-- For dynamic data loading, add a line that `requires` this asset and `returns` the result
	else
		local RankThreshold_RemoteFunction = script:WaitForChild("RankThreshold_RemoteFunction")
		return RankThreshold_RemoteFunction:InvokeServer("Get Rank Thresholds")
	end
end


---------- Types ----------

export type BadgeTierInfo = {
	badgeId: number,
	placeId: number,
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


---------- Constants ----------

local Constants = {}

do
	local _PieHikingTiers = script:WaitForChild("pie-hiking-tiers")
	Constants.badgeTierInfos = require(_PieHikingTiers:WaitForChild("tiered-badges"))
	Constants.rankThresholds = require(_PieHikingTiers:WaitForChild("tiered-ranks"))
end

table.freeze(Constants.badgeTierInfos)
table.freeze(Constants.rankThresholds)


---------- Globals ----------

local Globals = {}

Globals.badgeTierIds = {} :: {{number}}
Globals.rankPriority = {} :: {[string]: number}
Globals.badgePlaceId = {} :: {[string]: number}


---------- Local functions ----------

local function setUpBadgeTierIds()
	Globals.badgeTierIds = {}
	for i = 1, 10 do
		table.insert(Globals.badgeTierIds, {})
	end

	for _, badgeInfo in Constants.badgeTierInfos do
		local badgeId = badgeInfo.badgeId
		local tier = badgeInfo.tier

		while tier > #Globals.badgeTierIds do
			table.insert(Globals.badgeTierIds, {})
		end
		table.insert(Globals.badgeTierIds[tier], badgeId)
	end
end

local function setUpRankPriority()
	Globals.rankPriority = {}
	local maxIndex = #Constants.rankThresholds
	for index, rankThreshold in Constants.rankThresholds do
		Globals.rankPriority[rankThreshold.rankTitle] = maxIndex - index
	end
end

local function setUpBadgePlaceId()
	Globals.badgePlaceId = {}
	for _, badgeInfo in Constants.badgeTierInfos do
		local badgeId = badgeInfo.badgeId
		local placeId = badgeInfo.placeId
		Globals.badgePlaceId[tostring(badgeId)] = placeId
	end
end


---------- Calling functions ----------

setUpBadgeTierIds()
table.freeze(Globals.badgeTierIds)

setUpRankPriority()
table.freeze(Globals.rankPriority)

setUpBadgePlaceId()
table.freeze(Globals.badgePlaceId)


---------- Module ----------

local RankThresholds = {}


----- Module fields -----

RankThresholds.badgeTierInfos = Constants.badgeTierInfos
RankThresholds.badgeTierIds = Globals.badgeTierIds
RankThresholds.badgePlaceId = Globals.badgePlaceId

RankThresholds.rankThresholds = Constants.rankThresholds
RankThresholds.rankPriority = Globals.rankPriority


---------- Return module ----------

table.freeze(RankThresholds)
return RankThresholds
