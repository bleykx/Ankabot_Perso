FighterBotBankManager = {}

---@param botBank boolean
function FighterBotBankManager:new(botBank)
    dofile(global:getCurrentScriptDirectory() .. "\\Domain\\Managers\\BotsInfos.lua")

    local object = {}
    object.BotBank = botBank
    object.BotInfos = BotsInfos:New()

    setmetatable(object, self)
    self.__index = self
    return object
end

function FighterBotBankManager:PoseInventory()
    global:printMessage("PoseInventory")
    if self.BotBank then
        self:luBank()
    else
        self:NPCBank()
    end
end

function FighterBotBankManager:NPCBank()
    npc:npcBank(-1,-1)
    global:delay(2500)
    exchange:putAllItems()
    global:leaveDialog()
end