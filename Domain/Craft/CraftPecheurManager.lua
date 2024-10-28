CraftPecheurManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bots\\HumanityManager.lua")

function CraftPecheurManager:new()
    local object = {}
    object.HumanityManager = HumanityManager:new()

    setmetatable(object, self)
    self.__index = self
    return object
end

function CraftPecheurManager:CraftBeignetGreuvetteAstrub(craftQuantity)
    map:useById(516163, -1)
    global:delay(2148)
    craft:putItem(598, 2)
    global:delay(3476)
    craft:changeQuantityToCraft(craftQuantity)
    global:delay(2458)
    craft:ready()
    global:delay(4237)
    global:leaveDialog()
    global:delay(1258)
    global:printColor(Info, "[Information] : Craft de " .. craftQuantity .. " poissons effectué.")
    map:moveToCell(457)
    NeedToCraft = false
    NeedToReturnBank = true
    global:delay(3259)
end

function CraftPecheurManager:CheckQuantityBeignetGreuvetteInInventory()
    local NbGreuvette = inventory:itemCount(598)
    local quantityToCraft = 0

    if NbGreuvette > 2 then
        quantityToCraft = math.floor(NbGreuvette / 2)
    end

    return quantityToCraft
end

function CraftPecheurManager:CheckQuantityBeignetGreuvetteInBank()
    local NbGreuvette = exchange:storageItemQuantity(598)
    local quantityToCraft = 0
    local podsAvailable = inventory:podsMax() - inventory:pods()
    local maxQuantityToCraft = podsAvailable / 4

    if NbGreuvette > 2 then
        quantityToCraft = math.floor(NbGreuvette / 2)
        if quantityToCraft > maxQuantityToCraft then
            quantityToCraft = maxQuantityToCraft
        end
    end

    return quantityToCraft
end