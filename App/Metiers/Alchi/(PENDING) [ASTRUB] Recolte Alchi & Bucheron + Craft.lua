AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8
BOT_BANK = true

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Craft\\CraftPaysanManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\Metier\\PathPaysanManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

local server = character:server()
local NeedToReturnBank = false
local quantityToCraft = 0

local PathManager = PathManager:new()
local PathPaysanManager = PathPaysanManager:new()
local CraftPaysanManager = CraftPaysanManager:new()
local FarmerBotBankManager = FarmerBotBankManager:new(BOT_BANK, server)
local lastPath = Path:new({}, "", false)

function move()

    if NeedToReturnBank then
        PathManager:BankAstrubFromAstrub()
        FarmerBotBankManager:PoseInventory()
        NeedToReturnBank = false
    end

    local path

    GATHER = {75, 84}
    path = PathPaysanManager:GatherAllCerealeAstrub()

    if lastPath.Name ~= path.Name then
        lastPath = path

        global:printColor(Info, "Nouveau trajet : " .. path.Name)
    end

    return path.Path
end

function bank()
    if job:level(36) < 60 then
        quantityToCraft = CraftPaysanManager:CheckQuantityForMichetteInInventory()
        if quantityToCraft > 0 then
            PathPaysanManager:AtelierPaysanAstrub()
            CraftPaysanManager:CraftMichetteAstrub(quantityToCraft)
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