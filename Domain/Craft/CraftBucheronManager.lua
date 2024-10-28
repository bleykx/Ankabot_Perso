CraftBucheronManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

function CraftBucheronManager:new()
    local self = {}
    setmetatable(self, CraftBucheronManager)
    self.__index = CraftBucheronManager
    return self
end

function CraftBucheronManager:CraftPlancheRenforceeAstrub(craftQuantity)
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