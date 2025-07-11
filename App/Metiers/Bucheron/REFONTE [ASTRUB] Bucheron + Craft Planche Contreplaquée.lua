AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8
BOT_BANK = true

dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\PathManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Craft\\CraftBucheronManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bank\\FarmerBotBankManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Path\\Metier\\PathBucheronManager.lua")
dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Enums\\LogEnum.lua")

local server = character:server()
local NeedToReturnBank = false
local quantityToCraft = 0

local PathManager = PathManager:new()
local PathBucheronManager = PathBucheronManager:new()
local CraftBucheronManager = CraftBucheronManager:new()
local FarmerBotBankManager = FarmerBotBankManager:new(BOT_BANK, server)
local lastPath = Path:new({}, "", false)

function move()

    if NeedToReturnBank then
        PathManager:BankAstrubFromAstrub()
        FarmerBotBankManager:PoseInventory()
        NeedToReturnBank = false
    end

    local path

    GATHER =  {1, 8, 33, 84}
    path = PathBucheronManager:GatherBoisAstrub()
    
    if lastPath.Name ~= path.Name then
        lastPath = path

        global:printColor(Info, "Nouveau trajet : " .. path.Name)
    end

    return path.Path
end

function bank()
    quantityToCraft = CraftBucheronManager:CheckQuantityForPlancheContreplaqueeInInventory()
    if quantityToCraft > 0 then
        PathBucheronManager:AtelierBucheronAstrub()
        CraftBucheronManager:CraftPlancheContreplaqueeAstrub(quantityToCraft)
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