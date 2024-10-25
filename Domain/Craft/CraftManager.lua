CraftManager = {}

function CraftManager:new()
    local self = {}
    setmetatable(self, CraftManager)
    self.__index = CraftManager
    return self
end

function CraftManager:CraftPotionSouvenirAstrub(craftQuantity)
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
    map:moveToCell(396)
end