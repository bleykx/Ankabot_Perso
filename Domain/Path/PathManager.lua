PathManager = {}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Models\\Path.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")


function PathManager:new()

    local object = {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function PathManager:IncarnamToAstrub()

    return{
        -- nord d'incarnam
        {map = "-3,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-2,-5", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "-2,-4", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "4,-4", path = "left"},
        -- cimetiere
        {map = "5,-1", path = "left"},
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "left"},
        {map = "4,-1", path = "bottom"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        -- sud d'incarnam
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-2,0", path = "top"},
        {map = "-1,0", path = "left"},
        {map = "0,0", path = "right"},
        {map = "1,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "0,-1", path = "right"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "0,-2", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "3,-2", path = "top"},
        -- route des ames
        {map = "-2,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "2,-3", path = "right"},
        {map = "3,-3", path = "right"},
        { map = "153880835", custom = function() npc:npc(4398,3) npc:reply(-1) npc:reply(-1) end, done = false },
        -- route d'astrub
	--[[6,-19]]    { map = "192416776", path = "bottom(550)", done = false },
	--[[6,-19]]    { map = "191106048", path = "left(350)", done = false },
	               { map = "5,-18", path = "left", done = false },
                   { map = "5,-19", path = "bottom", done = false },
	--[[4,-19]]    { map = "191104000", path = "bottom(540)", done = false }, -- se place sur la map exete banque
    }
end

function PathManager:AtrubToIncarnam()
    
end

function PathManager:ReturnAstrub()
    map:moveToward(191104000)
end

function PathManager:BankAstrubFromAstrub()
    return map:moveToward(192415750)
end

function PathManager:FarmRouteDesAmes()
    return {
        {map = "4,-1", path = "bottom"},
        {map = "5,-1", path = "left"},
        {map = "4,0", path = "left"},
        {map = "5,0", path = "left"},
        {map = "4,1", path = "top"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "2,0", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "0,-2", path = "top"},
        {map = "0,-1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "left"},
        {map = "-2,0", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-3,-5", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-2,-5", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "4,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "-2,-4", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "152044547", path = "right"},
        {map = "152043521", path = "right"},
        {map = "152045573", path = "right"},
        {map = "152046593", path = "right"},
        {map = "152043523", path = "right"},
        {map = "152046599", path = "right"},
        {map = "152044553", path = "right"},
        {map = "152046595", path = "right"},
        {map = "152044545", path = "right"},
        {map = "152045575", path = "right"},
        {map = "152045571", path = "right"},
        {map = "152043529", path = "right"},
        {map = "152043527", path = "right"},
        {map = "152043525", path = "right"},
        {map = "152045569", path = "right"},
        {map = "152046597", path = "right"},
        {map = "152044549", path = "right"},
        {map = "153092354", door = "409"},
        -- Cartes de combats
        {map = "-1,-3", path = "left|right", fight = true},
        {map = "-2,-3", path = "right", fight = true},
        {map = "3,-3", path = "left", fight = true},
        {map = "0,-3", path = "left|right", fight = true},
        {map = "1,-3", path = "left|right", fight = true},
        {map = "2,-3", path = "left|right", fight = true},
    }
end

function PathManager:FarmChampsIncarnam()
    return {
        {map = "-1,-2", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-2,-3", path = "top"},
        {map = "3,-3", path = "left"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "1,0", path = "top"},
        {map = "0,-1", path = "right"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "top"},
        {map = "-2,0", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "4,-3", path = "left"},
        {map = "4,-4", path = "left"},
        {map = "2,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "3,-1", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "0,-2", path = "top"},
        {map = "2,-3", path = "left"},
        {map = "1,-3", path = "left"},
        {map = "0,-3", path = "left"},
        {map = "-1,-3", path = "top"},
        -- Cartes de combats
        {map = "-3,-6", path = "bottom", fight = true},
        {map = "-1,-6", path = "left", fight = true},
        {map = "-1,-5", path = "top|left", fight = true},
        {map = "0,-5", path = "left", fight = true},
        {map = "-2,-6", path = "left|bottom", fight = true},
        {map = "-2,-5", path = "bottom", fight = true},
        {map = "-2,-4", path = "right", fight = true},
        {map = "-3,-5", path = "right", fight = true},
        {map = "0,-4", path = "top", fight = true},
        {map = "-1,-4", path = "top|right", fight = true}
    }
end

function PathManager:FarmLacIncarnam()
    return {
        {map = "-1,-4", path = "bottom"},
        {map = "-1,-3", path = "bottom"},
        {map = "0,0", path = "right"},
        {map = "1,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "0,-3", path = "left"},
        {map = "1,-3", path = "left"},
        {map = "2,-3", path = "left"},
        {map = "3,-3", path = "left"},
        {map = "-2,-3", path = "bottom"},
        {map = "1,-2", path = "left"},
        {map = "1,-1", path = "top"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "4,-1", path = "bottom"},
        {map = "5,0", path = "left"},
        {map = "5,-1", path = "left"},
        {map = "4,1", path = "left"},
        {map = "4,0", path = "left"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "3,-2", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "4,-3", path = "left"},
        {map = "4,-4", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "-2,-5", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "0,-4", path = "left"},
        {map = "0,-5", path = "left"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        -- Cartes de combats
        {map = "-2,0", path = "right", fight = true},
        {map = "-2,-1", path = "right|bottom", fight = true},
        {map = "-2,-2", path = "bottom", fight = true},
        {map = "-1,-2", path = "left|right|bottom", fight = true},
        {map = "-1,-1", path = "top|left", fight = true},
        {map = "0,-1", path = "right", fight = true},
        {map = "0,1", path = "top", fight = true},
        {map = "-1,1", path = "right", fight = true},
        {map = "-1,0", path = "top|right|bottom", fight = true},
        {map = "0,-2", path = "left", fight = true},
    }
end

function PathManager:FarmForetIncarnam()
    return {
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "left"},
        {map = "3,0", path = "top"},
        {map = "3,1", path = "top"},
        {map = "-1,-6", path = "bottom"},
        {map = "-2,-6", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "0,1", path = "top"},
        {map = "3,-3", path = "left"},
        {map = "3,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-3", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "-1,1", path = "top"},
        {map = "-1,0", path = "right"},
        {map = "-2,0", path = "right"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "-2,-1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "0,-2", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "1,-3", path = "bottom"},
        {map = "0,-1", path = "bottom"},
        {map = "0,0", path = "right"},
        -- Cartes de combats
        {map = "2,0", path = "top", fight = true},
        {map = "1,0", path = "right", fight = true},
        {map = "1,-1", path = "bottom", fight = true},
        {map = "2,-2", path = "right|bottom", fight = true},
        {map = "1,-2", path = "right", fight = true},
        {map = "3,-1", path = "top", fight = true},
        {map = "2,-1", path = "right", fight = true},
        {map = "3,-2", path = "left", fight = true},
    }
end

function PathManager:FarmPaturageIncarnam()
    return {
        {map = "3,-1", path = "left"},
        {map = "2,-3", path = "top"},
        {map = "0,0", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "1,0", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "2,0", path = "top"},
        {map = "3,-3", path = "top"},
        {map = "4,1", path = "top"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-1,0", path = "right"},
        {map = "5,-1", path = "bottom"},
        {map = "4,-1", path = "bottom"},
        {map = "4,0", path = "left"},
        {map = "4,3", path = "left"},
        {map = "5,0", path = "left"},
        {map = "-3,-5", path = "right"},
        {map = "-3,-6", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "0,-5", path = "right"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "-1,-4", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "-2,0", path = "right"},
        {map = "0,-2", path = "right"},
        {map = "-1,-2", path = "right"},
        {map = "-2,-2", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "3,-2", path = "left"},
        {map = "1,-2", path = "right"},
        -- Cartes de combats
        {map = "1,-4", path = "right", fight = true},
        {map = "1,-5", path = "bottom", fight = true},
        {map = "2,-5", path = "left", fight = true},
        {map = "3,-5", path = "left", fight = true},
        {map = "2,-4", path = "top|right", fight = true},
        {map = "3,-4", path = "top", fight = true},
    }
end

function PathManager:FarmCimetiereIncarnam()
    return {
        {map = "-1,-4", path = "right"},
        {map = "3,-2", path = "left"},
        {map = "2,0", path = "top"},
        {map = "1,-2", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "1,0", path = "top"},
        {map = "-1,-6", path = "bottom"},
        {map = "-2,-6", path = "bottom"},
        {map = "-3,-6", path = "bottom"},
        {map = "-3,-5", path = "right"},
        {map = "0,-5", path = "right"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "3,-4", path = "left"},
        {map = "-2,-4", path = "right"},
        {map = "0,-3", path = "right"},
        {map = "-1,-3", path = "right"},
        {map = "-2,-3", path = "right"},
        {map = "1,-3", path = "right"},
        {map = "1,-4", path = "right"},
        {map = "1,-5", path = "right"},
        {map = "2,-5", path = "bottom"},
        {map = "3,-5", path = "left"},
        {map = "-2,-2", path = "top"},
        {map = "-1,-2", path = "top"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-2,0", path = "right"},
        {map = "-1,0", path = "right"},
        {map = "3,-3", path = "left"},
        {map = "2,-4", path = "bottom"},
        {map = "2,-3", path = "bottom"},
        {map = "2,-2", path = "bottom"},
        {map = "4,-4", path = "left"},
        {map = "4,-3", path = "left"},
        {map = "2,-1", path = "right"},
        {map = "3,-1", path = "bottom"},
        {map = "0,0", path = "right"},
        -- Cartes de combats
        {map = "3,1", path = "right", fight = true},
        {map = "4,0", path = "left|right", fight = true},
        {map = "4,-1", path = "bottom", fight = true},
        {map = "4,1", path = "top", fight = true},
        {map = "5,-1", path = "left", fight = true},
        {map = "3,0", path = "bottom", fight = true},
        {map = "5,0", path = "top", fight = true},
    }
end

function PathManager:AtelierForgeronIncarnamFromIncarnam()
    return {
        {map = "-3,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "-2,-6", path = "right"},
        {map = "-2,-5", path = "right"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "right"},
        {map = "-2,-4", path = "right"},
        {map = "-1,-4", path = "right"},
        {map = "0,-5", path = "right"},
        {map = "0,-4", path = "right"},
        {map = "1,-5", path = "right"},
        {map = "1,-4", path = "right"},
        {map = "3,-5", path = "left"},
        {map = "3,-4", path = "left"},
        {map = "4,-4", path = "left"},
        {map = "3,1", path = "top"},
        {map = "4,0", path = "left"},
        {map = "4,-1", path = "bottom"},
        {map = "4,1", path = "left"},
        {map = "5,-1", path = "left"},
        {map = "5,0", path = "left"},
        {map = "3,0", path = "top"},
    -- direction atelier
        {map = "3,-1", path = "left"},
        {map = "2,-1", path = "top"},
        {map = "2,-2", path = "top"},
        {map = "2,-3", path = "top"},
        {map = "2,-4", door = "330"},
        {map = "2,-5", path = "bottom"},
        {map = "153355264", custom = craftchasseur},
    }
end

function PathManager:AtelierChasseurIncarnamFromIncarnam()
    return {
        -- nord d'incarnam
        {map = "-3,-6", path = "right"},
        {map = "-3,-5", path = "right"},
        {map = "-2,-6", path = "bottom"},
        {map = "-2,-5", path = "bottom"},
        {map = "-1,-6", path = "bottom"},
        {map = "-1,-5", path = "bottom"},
        {map = "-2,-4", path = "bottom"},
        {map = "-1,-4", path = "bottom"},
        {map = "0,-5", path = "bottom"},
        {map = "0,-4", path = "bottom"},
        {map = "1,-5", path = "bottom"},
        {map = "1,-4", path = "bottom"},
        {map = "2,-5", path = "bottom"},
        {map = "2,-4", path = "bottom"},
        {map = "3,-5", path = "bottom"},
        {map = "3,-4", path = "bottom"},
        {map = "4,-4", path = "left"},
        -- cimetiere
        {map = "5,-1", path = "left"},
        {map = "5,0", path = "left"},
        {map = "4,0", path = "left"},
        {map = "4,1", path = "left"},
        {map = "4,-1", path = "bottom"},
        {map = "3,1", path = "top"},
        {map = "3,0", path = "top"},
        -- sud d'incarnam
        {map = "0,1", path = "top"},
        {map = "-1,1", path = "top"},
        {map = "-2,0", path = "top"},
        {map = "-1,0", path = "left"},
        {map = "0,0", path = "right"},
        {map = "1,0", path = "top"},
        {map = "2,0", path = "top"},
        {map = "3,-1", path = "top"},
        {map = "2,-1", path = "top"},
        {map = "1,-1", path = "top"},
        {map = "0,-1", path = "right"},
        {map = "-1,-1", path = "top"},
        {map = "-2,-1", path = "top"},
        {map = "-2,-2", path = "right"},
        {map = "0,-2", path = "left"},
        {map = "1,-2", path = "left"},
        {map = "2,-2", path = "left"},
        {map = "3,-2", path = "left"},
        -- route des ames
        {map = "-2,-3", path = "right"},
        {map = "-1,-3", path = "bottom"},
        {map = "0,-3", path = "left"},
        {map = "1,-3", path = "left"},
        {map = "2,-3", path = "left"},
        {map = "3,-3", path = "left"},
        {map = "4,-3", path = "left"},
        -- map action
        {map = "154010370", door = " 301"}, -- map exte atelier chasseur
        {map = "153355268", custom = craftlesviandes}, -- map inte atelier chasseur
    }
end

function PathManager:SortirTempleAstrub()
    return {
        { map = "192416776", path = "bottom(550)", done = false, custom = function() global:printSuccess("[PathManager] Sortie du temple d'Astrub") end }
    }
end

function PathManager:SortirBanqueAstrub()
    return{
        { map = "192415750", path = "424" },
    }
end

function PathManager:EntrerBanqueAstrub()
    return{
        { map = "191104002", door = "288" },
    }
end

function PathManager:GoPhoenixAstrub()
    return {
        { map = "-3,-11", path = "top" },
        { map = "-3,-12", path = "right" },
        { map = "-2,-12", path = "right" },
        { map = "-1,-12", path = "right" },
        { map = "0,-12", path = "right" },
        { map = "1,-12", path = "right" },
        { map = "-2,-11", path = "top" },
        { map = "-1,-11", path = "top" },
        }
end