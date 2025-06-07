--!strict
-- Rank Thresholds Module Script


---------- Module ----------

local RankThresholds = {}


---------- Types ----------

export type MinBadgeCondition = {
	badgeIds: {number},
	minimumBadges: number,
}

export type RankTreshold = {
	rankTitle: string,
	conditions: {MinBadgeCondition}
}


---------- Variables ----------

local pieHikeBadgeIds = {
	[1] = {
		2124804350, 762842082907600, 2373979332798747, 10610597812, 2128588095,
		1733818730683290, 3970039654192782, 323519880349903,
	},
	[2] = {
		447375146193187, 4492276884984762,
		2124874992, 2126097921, 1149275490298835, 2126028317, 1304145351760118,
		3413930070767912, 3121449077844905, 2603426785530276, 4234692773362308, 2148559046,
		2145332648, 2146451319, 1817236229139128, 138393846301980, 4120725793479014,
		75672742138460, 2302476059092707, 3289653190402308, 3152652624960997, 3240746798610339,
		2757758234901820,
	},
	[3] = {
		3099629539280325,
		3962996141777733,
	},
	[4] = {}
}

-- Thresholds from highest to lowest rank
local rankThresholds: {RankTreshold} = {
	{
		rankTitle = "S+",
		conditions = {
			{badgeIds = pieHikeBadgeIds[4], minimumBadges = 5},
			{badgeIds = pieHikeBadgeIds[3], minimumBadges = 15},
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 15},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 15},
		}
	},
	{
		rankTitle = "S",
		conditions = {
			{badgeIds = pieHikeBadgeIds[4], minimumBadges = 1},
			{badgeIds = pieHikeBadgeIds[3], minimumBadges = 10},
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 10},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 10},
		}
	},
	{
		rankTitle = "A+",
		conditions = {
			{badgeIds = pieHikeBadgeIds[3], minimumBadges = 5},
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 10},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 10},
		}
	},
	{
		rankTitle = "A",
		conditions = {
			{badgeIds = pieHikeBadgeIds[3], minimumBadges = 1},
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 10},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 5},
		}
	},
	{
		rankTitle = "Master",
		conditions = {
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 5},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 5},
		}
	},
	{
		rankTitle = "Pro",
		conditions = {
			{badgeIds = pieHikeBadgeIds[2], minimumBadges = 1},
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 5},
		}
	},
	{
		rankTitle = "Novice",
		conditions = {
			{badgeIds = pieHikeBadgeIds[1], minimumBadges = 3},
		}
	},
	{
		rankTitle = "Beginner",
		conditions = {
			{badgeIds = {}, minimumBadges = 0}
		}
	},
}

table.freeze(rankThresholds)


---------- Module variables ----------

RankThresholds.pieHikeBadgeIds = pieHikeBadgeIds
RankThresholds.rankThresholds = rankThresholds


---------- Return module ----------

return RankThresholds

