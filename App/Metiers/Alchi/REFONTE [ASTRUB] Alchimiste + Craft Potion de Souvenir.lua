AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8
BOT_BANK = true

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Craft\\CraftAlchimisteManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\Metier\\PathAlchimisteManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

local server = character:server()
local NeedToReturnBank = false
local quantityToCraft = 0

local PathManager = PathManager:new()
local PathAlchimisteManager = PathAlchimisteManager:new()
local CraftAlchimisteManager = CraftAlchimisteManager:new()
local FarmerBotBankManager = FarmerBotBankManager:new(BOT_BANK, server)
local lastPath = Path:new({}, "", false)

function move()

    if NeedToReturnBank then
        PathManager:BankAstrubFromAstrub()
        FarmerBotBankManager:PoseInventory()
        NeedToReturnBank = false
    end

    local path

    -- Définition du chemin à suivre en fonction du niveau du métier Alchimiste
    if (job:level(26) < 20) then
        GATHER = {254, 255, 1, 8, 28, 29, 30, 31, 32, 33, 34, 35, 39, 42, 43, 44, 45, 46, 47, 61, 66, 67, 68, 74, 76, 77, 78, 79, 80, 81, 98, 99, 101, 108,109, 110, 111, 112}
        return PathAlchimisteManager:GatherOrtieAstrub()
    elseif (job:level(26) >= 20) then
        GATHER = {254, 255, 1, 8, 28, 29, 30, 31, 32, 33, 34, 35, 39, 42, 43, 44, 45, 46, 47, 61, 66, 67, 68, 74, 76, 77, 78, 79, 80, 81, 98, 99, 101, 108,109, 110, 111, 112}
        return PathAlchimisteManager:GatherOrtieAndSaugeAstrub()
    end

    if lastPath.Name ~= path.Name then
        lastPath = path

        global:printColor(Info, "Nouveau trajet : " .. path.Name)
    end

    return path.Path
end

function bank()
    quantityToCraft = CraftAlchimisteManager:CheckQuantityForPotionSouvenirInInventory()
    if quantityToCraft > 0 then
        PathAlchimisteManager:AtelierAlchimisteAstrub()
        CraftAlchimisteManager:CraftPotionSouvenirAstrub(quantityToCraft)
        NeedToReturnBank = true
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