local rollType = 3
local rollTypes = {}
rollTypes["pass"]       = 0;
rollTypes["greed"]      = 2;
rollTypes["disenchant"] = 3;
rollTypes["need"]       = 1


local function canGreedItem(_, canGreed, _)
    return canGreed
end
local function canNeedItem(canNeed, _, _)
    return canNeed
end
local function canDisenchantItem(_, _, canDisenchant)
    return canDisenchant
end

local canRoll = {}
canRoll[0] = function(...)
        return true
    end
canRoll[2] = canGreedItem
canRoll[3] = canDisenchantItem
canRoll[1] = canNeedItem

local function rollOnLoot(self, event, ...)
    local rollId, _ = ...
    if event == "START_LOOT_ROLL" then
        local _, _, _, quality, _, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollId)
        if quality <= 3 and canRoll[rollType](canNeed, canGreed, canDisenchant) then
            RollOnLoot(rollId, rollType)
        end
    else
        ConfirmLootRoll(rollId, rollType)
    end
end

local function rollTypeExists(rT)
    return rollTypes[rT] ~= nil
end

local function usage()
    print("Usable values: pass, greed, disenchant, need")
end

local function setRollType(rT)
    if not rollTypeExists(rT:lower()) then
        print('Roll type:' .. rT .. " does not exist!")
        usage()
        return
    end
    rollType = tonumber(rollTypes[rT])
    print("Roll type set to:" .. rT)
end

local AutoRoll = CreateFrame("Frame", "AutoRoll_Frame")
AutoRoll:RegisterEvent("START_LOOT_ROLL")
AutoRoll:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
AutoRoll:RegisterEvent("CONFIRM_LOOT_ROLL")
AutoRoll:SetScript("OnEvent", rollOnLoot)

SLASH_AUTOROLLER1 = "/autoroller"
SlashCmdList["AUTOROLLER"] = setRollType