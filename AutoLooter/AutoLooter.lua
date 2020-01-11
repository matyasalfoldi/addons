local function shouldNotLoot()
    -- returns 0 if you are not in a raid or party type group.
    return GetNumGroupMembers() ~= 0
end

local function lootItems()
    if shouldNotLoot() then
        return
    end
    local itemCount = GetNumLootItems()
    for slot=1, itemCount do
        local _, name, _, rarity = GetLootSlotInfo(slot)
        if LootSlotIsCoin(slot) or rarity > 1 then
            LootSlot(slot)
        end
    end
end

local function handleEvents(self, event, ...)
    if event == "LOOT_OPENED" then
        lootItems()
    else
        local lootSlot = ...
        ConfirmLootSlot(lootSlot)
    end
end

local AutoLoot = CreateFrame("Frame", "AutoLoot_Frame")
AutoLoot:RegisterEvent("LOOT_OPENED")
AutoLoot:RegisterEvent("LOOT_BIND_CONFIRM")
AutoLoot:SetScript("OnEvent", handleEvents)