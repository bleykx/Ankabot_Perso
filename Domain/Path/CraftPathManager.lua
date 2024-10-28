CraftPathManager = {}

function CraftPathManager:new()
    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function CraftPathManager:AtelierPaysanAstrub()
    map:moveToward(192939008)
end

function CraftPathManager:AtelierChasseurAstrub()
    map:moveToward(192937994)
end

function CraftPathManager:AtelierPecheurAstrub()
    map:moveToward(192937984)
end

function CraftPathManager:AtelierBucheronAstrub()
    map:moveToward(192940042)
end

function CraftPathManager:AtelierAlchimisteAstrub()
    map:moveToward(192937988)
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