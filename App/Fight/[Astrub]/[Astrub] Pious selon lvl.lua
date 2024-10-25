MAX_PODS = 90
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 1
OPEN_BAGS = true
FORCE_MONSTERS = {}
FORBIDDEN_MONSTERS = {463}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\FightPathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Stuff\\StuffManager.lua")

local BotBank = false
local Server = character:server()

local FarmerBotBankManager = FarmerBotBankManager:new(BotBank, Server)
local PathManager = PathManager:new()
local FightPathManager = FightPathManager:new()

local FullPano = false
local BankMapId = 192415750  -- Astrub
local OutdoorBankMapId = 191104002 -- Astrub
BotBanque = true

function move()

    if (character:level() >= 12 and FullPano == false) then
        FullPano = StuffManager:EquipPanoPiou()
    end
    CheckLvl()
    if(map:currentMapId() == BankMapId) then
        global:printMessage("[Move] Je vais sortir de la banque")
        return PathManager:SortirBanqueAstrub()
    end

    return FightPathManager:FarmPiouAstrub()
end

function bank()
    if(map:currentMapId() == BankMapId) then
        FarmerBotBankManager:PoseInventory()
        global:printMessage("[Bank] Je vais sortir de la banque")
        return PathManager:SortirBanqueAstrub()
    else
        return PathManager:BankAstrubFromAstrub()
    end
end


function phenix()
    return {
        { map = "-3,-13", path = "top" },
        { map = "-2,-14", path = "right" },
        { map = "-3,-14", path = "right" },
        { map = "-1,-14", path = "right" },
        { map = "0,-14", path = "right" },
        { map = "1,-14", path = "right" },
        { map = "2,-14", custom = function() map:door(313) map:changeMap("top") end, done = false },
    }
end

function stopped()
end

function banned()
end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)
end

function CheckLvl()
    if (character:level() < 10 ) then
        MIN_MONSTERS = 1
        MAX_MONSTERS = 1
        global:printSuccess("[Script] : Changement du nombre de monstre [1-1]")
        return
    elseif(character:level() < 20) then
        MIN_MONSTERS = 1
        MAX_MONSTERS = 2
        global:printSuccess("[Script] : Changement du nombre de monstre [1-2]")
        return
    elseif(character:level() < 25) then
        MIN_MONSTERS = 1
        MAX_MONSTERS = 3
        ForceColoredPiou()
        global:printSuccess("[Script] : Changement du nombre de monstre [1-3]")
        return
    elseif(character:level() < 30) then
        MIN_MONSTERS = 1
        MAX_MONSTERS = 4
        ForceColoredPiou()
        global:printSuccess("[Script] : Changement du nombre de monstre [1-4]")
        return
    elseif(character:level() >= 30) then
        MIN_MONSTERS = 2
        MAX_MONSTERS = 6
        ForceColoredPiou()
        global:printSuccess("[Script] : Changement du nombre de monstre [2-6]")
        return
    elseif(character:level() >= 38) then
        MIN_MONSTERS = 2
        MAX_MONSTERS = 8
        ForceColoredPiou()
        global:printSuccess("[Script] : Changement du nombre de monstre [2-8] (max palier)")
        return
    end
end

function ForceColoredPiou()
    if (FullPano) then
        global:printSuccess("[Script] : FullPano actif")
        FORCE_MONSTERS = {}
        return
    end
    if (character:getChanceBase() > 30) then
        FORCE_MONSTERS = {491}
        global:printSuccess("[Script] : Forcage du monstre [Piou Bleu]")
        return
    end
    if (character:getAgilityBase() > 30) then
        FORCE_MONSTERS = {490}
        global:printSuccess("[Script] : Forcage du monstre [Piou Vert]")
        return
    end
    if (character:getIntelligenceBase() > 30) then
        FORCE_MONSTERS = {489}
        global:printSuccess("[Script] : Forcage du monstre [Piou Rouge]")
        return
    end
    if (character:getStrenghtBase() > 30) then
        FORCE_MONSTERS = {493}
        global:printSuccess("[Script] : Forcage du monstre [Piou Jaune]")
        return
    end
end