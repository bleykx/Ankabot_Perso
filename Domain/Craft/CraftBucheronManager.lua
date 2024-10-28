CraftBucheronManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

function CraftBucheronManager:new()
    local self = {}
    setmetatable(self, CraftBucheronManager)
    self.__index = CraftBucheronManager
    return self
end

function CraftBucheronManager:CraftPlancheContreplaqueeAstrub(craftQuantity)
    map:useById(515879, -1)
    global:delay(2148)
    craft:putItem(303, 10)
    global:delay(1678)
    craft:putItem(473, 10)
    global:delay(3476)
    craft:changeQuantityToCraft(craftQuantity)
    global:delay(2458)
    craft:ready()
    global:delay(4237)
    global:leaveDialog()
    global:delay(1258)
    global:printColor(Info, "[Information] : Craft de " .. craftQuantity .. " planches renforcées effectué.")
    map:moveToCell(414)
    NeedToCraft = false
    NeedToReturnBank = true
    global:delay(3259)
end

function CraftBucheronManager:CheckQuantityForPlancheContreplaqueeInInventory()
    local NbFrene = inventory:itemCount(303)
    local NbChataignier = inventory:itemCount(473)
    local quantityToCraft = 0
    local podsAvailable = inventory:podsMax() - inventory:pods()
    local maxQuantityToCraft = podsAvailable / 100

    if (NbFrene > 10 and NbChataignier > 10) then
        local lowestQuantity = math.min(NbFrene, NbChataignier)
        quantityToCraft = math.floor(lowestQuantity / 10)
        if quantityToCraft > maxQuantityToCraft then
            quantityToCraft = maxQuantityToCraft
        end
    end

    return quantityToCraft
end

function CraftBucheronManager:GetItemForPlancheContreplaqueeFromBank()
    local NbFrene = exchange:storageItemQuantity(303)
    local NbChataignier = exchange:storageItemQuantity(473)
    local quantityToCraft = 0
    local podsAvailable = math.floor(inventory:podsMax() - inventory:pods() / 2)
    local maxQuantityToCraft = podsAvailable / 100

    if (NbFrene > 10 and NbChataignier > 10) then
        local lowestQuantity = math.min(NbFrene, NbChataignier)
        quantityToCraft = math.floor(lowestQuantity / 10)
        if quantityToCraft > maxQuantityToCraft then
            quantityToCraft = maxQuantityToCraft
        end
    end

    exchange:getItem(303, quantityToCraft * 10)
    exchange:getItem(473, quantityToCraft * 10)
end