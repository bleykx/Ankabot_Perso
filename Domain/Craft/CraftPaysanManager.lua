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

