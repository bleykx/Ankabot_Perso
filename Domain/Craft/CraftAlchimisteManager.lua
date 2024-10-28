CraftAlchimisteManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bots\\HumanityManager.lua")

function CraftAlchimisteManager:new()
    local self = {}
    setmetatable(self, CraftAlchimisteManager)
    self.__index = CraftAlchimisteManager
    return self
end

function CraftAlchimisteManager:CraftPotionSouvenirAstrub(craftQuantity)
    map:useById(515520, -1)
    global:delay(2148)
    craft:putItem(428, 10)
    global:delay(1678)
    craft:putItem(421, 20)
    global:delay(3476)
    craft:changeQuantityToCraft(craftQuantity)
    global:delay(2458)
    craft:ready()
    global:delay(4237)
    global:leaveDialog()
    global:delay(1258)
    global:printColor(Info, "[Information] : Craft de " .. craftQuantity .. " potions souvenir effectué.")
    map:moveToCell(396)
end

function CraftAlchimisteManager:CheckQuantityForPotionSouvenirInInventory()
    local NbOrtie = inventory:itemCount(421)
    local NbSauge = inventory:itemCount(428)
    local quantityToCraft = 0
    local quantityPerOrtie = math.floor(NbOrtie / 20)
    local quantityPerSauge = math.floor(NbSauge / 10)

    if quantityPerOrtie >= 1 and quantityPerSauge >= 1 then
        local lowestQuantity = math.min(quantityPerOrtie, quantityPerSauge)
        quantityToCraft = lowestQuantity
    end

    return quantityToCraft
end


function CraftAlchimisteManager:GetItemForPotionSouvenirFromBank()
    local NbOrtie = exchange:storageItemQuantity(421)
    local NbSauge = exchange:storageItemQuantity(428)
    local quantityToCraft = 0
    local poidsAvailable = inventory:podsMax() - inventory:pods()
    local maxQuantityToCraft = poidsAvailable / 30
    local quantityPerOrtie = math.floor(NbOrtie / 20)
    local quantityPerSauge = math.floor(NbSauge / 10)

    if quantityPerOrtie >= 1 and quantityPerSauge >= 1 then
        local lowestQuantity = math.min(quantityPerOrtie, quantityPerSauge)
        quantityToCraft = lowestQuantity
        if quantityToCraft > maxQuantityToCraft then
            quantityToCraft = maxQuantityToCraft
        end
    end

    exchange:getItem(421, quantityToCraft * 20)
    exchange:getItem(428, quantityToCraft * 10)
end