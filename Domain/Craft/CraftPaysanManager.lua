CraftPaysanManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

function CraftPaysanManager:new()
    local self = {}
    setmetatable(self, CraftPaysanManager)
    self.__index = CraftPaysanManager
    return self
end

function CraftPaysanManager:CraftMichetteAstrub(craftQuantity)
    map:useById(515683, -1)
    global:delay(2148)
    craft:putItem(289, 5)
    global:delay(3476)
    craft:changeQuantityToCraft(craftQuantity)
    global:delay(2458)
    craft:ready()
    global:delay(4237)
    global:leaveDialog()
    global:delay(1258)
    global:printColor(Info, "[Information] : Craft de " .. craftQuantity .. " michettes effectué.")
    map:door(424)
    NeedToCraft = false
    NeedToReturnBank = true
    global:delay(3259)
end

function CraftPaysanManager:CheckQuantityForMichetteInInventory()
    local NbBle = inventory:itemCount(289)
    local quantityToCraft = 0

    if NbBle > 5 then
        quantityToCraft = math.floor(NbBle / 5)
    end

    return quantityToCraft
end

function CraftPaysanManager:GetItemForMichetteFromBank()
    local NbBle = exchange:storageItemQuantity(289)
    local quantityToCraft = 0
    local podsAvailable = inventory:podsMax() - inventory:pods()
    local maxQuantityToCraft = podsAvailable / 10

    if NbBle > 2 then
        quantityToCraft = math.floor(NbBle / 2)
        if quantityToCraft > maxQuantityToCraft then
            quantityToCraft = maxQuantityToCraft
        end
    end

    exchange:getItem(289, quantityToCraft * 5)
end