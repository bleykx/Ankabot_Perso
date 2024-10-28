MAX_PODS = 90
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 1
OPEN_BAGS = true
FORCE_MONSTERS = {}
FORBIDDEN_MONSTERS = {463}

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\GatherPathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Stuff\\StuffManager.lua")

local BotBank = false
local Server = character:server()

local FarmerBotBankManager = FarmerBotBankManager:new(BotBank, Server)
local PathManager = PathManager:new()
local GatherPathManager = GatherPathManager:new()

local FullPano = false
local BankMapId = 192415750  -- Astrub
local BankOutdoorMapId = 191104002
BotBanque = true

local path = nil
local lastPath = nil

function move()
    if (map:currentMap() == "4, -19" or path == nil) then
        lastPath = path
        path = GatherPathManager:GetRandomAstrubGatherAllPath()
        while (path == lastPath) do
            path = GatherPathManager:GetRandomAstrubGatherAllPath()
        end
        global:printMessage("[Script] Je commence le trajet " .. path.PathName)
    end

    return path.Path
end

function bank()
    if (map:currentArea() == "Incarnam") then
        PathManager:IncarnamToAstrub()
    end
    if(map:currentMapId() == BankMapId) then
        FarmerBotBankManager:PoseInventory()
        global:printMessage("[Bank] Je vais sortir de la banque")
        return PathManager:SortirBanqueAstrub()
    elseif(map:currentMapId() == BankOutdoorMapId) then
            global:printMessage("[Bank] Je vais rentrer dans la banque")
            return PathManager:EntrerBanqueAstrub()
    end
    return PathManager:BankAstrubFromAstrub()
end

function phenix()
    return {
    }
end

function stopped()
end

function banned()
end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)
end