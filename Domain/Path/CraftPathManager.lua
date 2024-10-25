CraftPathManager = {}

function CraftPathManager:new()
    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function CraftPathManager:AtelierAlchiFromBankAstrub()
    return {
        {map = "191104002", path = "top"}, -- Map extérieure de la banque d'Astrub
        {map = "4,-19", path = "top"},
        {map = "4,-20", path = "top"},
        {map = "4,-21", path = "left"},
        {map = "188744705", door = "412"}, -- Map extérieure Atelier Alchimiste Astrub
        {map = "192937988", custom = ProcessCraft}, -- Map intérieur Atelier Alchimiste Astrub
    }
end

function CraftPathManager:BankAstrubFromAtelierAlchi()
    return {
        {map = "188744705", path = "right"}, -- Map extérieure Atelier Alchimiste Astrub
        {map = "4,-21", path = "bottom"},
        {map = "4,-20", path = "bottom"},
        {map = "4,-19", path = "bottom"},
        {map = "191104002", door = "288"}, -- Map extérieure de la banque d'Astrub
        {map = "192415750", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
    }
end

