AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8
BOT_BANK = true

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Craft\\CraftPecheurManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\Metier\\PathPecheurManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

local server = character:server()
local NbGreuvette = 0
local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local quantityToCraft = 0

local PathManager = PathManager:new()
local PathPecheurManager = PathPecheurManager:new()
local CraftPecheurManager = CraftPecheurManager:new()
local FarmerBotBankManager = FarmerBotBankManager:new(BOT_BANK, server)
local lastPath = Path:new({}, "", false)

function move()

    if NeedToReturnBank then
        PathManager:BankAstrubFromAstrub()
        FarmerBotBankManager:PoseInventory()
        NeedToReturnBank = false
    end

    local path

    if (job:level(36) < 10) then -- si pecheur n'est pas lvl 10 alors on focus le trajet GOUJON
        GATHER = {75, 84}
        path = PathPecheurManager:GatherGoujonAstrub()
    else
        GATHER = {71, 74, 75, 76, 77, 78, 79, 84}
        path = PathPecheurManager:GatherAllPoisonAstrub()
    end

    if lastPath.Name ~= path.Name then
        lastPath = path

        global:printColor(Info, "Nouveau trajet : " .. path.Name)
    end

    return path.Path
end

function bank()
    if job:level(36) < 60 then
        quantityToCraft = CraftPecheurManager:CheckQuantityBeignetGreuvetteInInventory()
        if quantityToCraft > 0 then
            PathPecheurManager:AtelierPecheurAstrub()
            CraftPecheurManager:CraftBeignetGreuvetteAstrub(quantityToCraft)
            NeedToReturnBank = true
        end
    end
    PathManager:BankAstrubFromAstrub()
    FarmerBotBankManager:PoseInventory()
end

function phenix()
    return {
    }
end

function stopped()
end

function banned()
    global:printError("Banned")
end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)
end