FarmerBotBankManager = {}

---@param botBank boolean
function FarmerBotBankManager:new(botBank, server)
    dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Bots\\BotsInfos.lua")

    local object = {}
    object.BotBank = botBank
    object.BotInfos = BotsInfos:New()
    object.Server = server

    setmetatable(object, self)
    self.__index = self
    return object
end

function FarmerBotBankManager:PoseInventory()
    if self.BotBank then
        self:ToBotBank()
    else
        self:ToNPCBank()
    end
end

function FarmerBotBankManager:ToNPCBank()
    npc:npcBank(-1,-1)
    global:delay(2500)
    exchange:putAllItems()
    global:leaveDialog()
        
end

function FarmerBotBankManager:ToBotBank()
    local id_banquier = self.BotInfos:GetBankerIds(self.Server)

    exchange:launchExchangeWithPlayer(id_banquier) -- La fonction pour lancer l'échange
    exchange:putAllItems() -- La fonction pour déposer tous les objets de l'inventaire
    exchange:putKamas(0) -- La fonction pour déposer tous les kamas
    exchange:ready() -- La fonction pour valider l'échange
end