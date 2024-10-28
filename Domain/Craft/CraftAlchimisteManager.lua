CraftAlchimisteManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\HumanityManager.lua")

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