BotsInfos = {}

function BotsInfos:new()
    local object = {}

    object.bankBots = {
        { server = "Imagiro", botId = 689242702115 },
        { server = "Orukam", botId = 1016646009124 },
        { server = "Tal Kasha", botId = 830878318882 },
        { server = "Hell Mina", botId = 581563842854 },
        { server = "Tylezia", botId = 848954065189 }
    }

    setmetatable(object, self)
    self.__index = self
    return object
end

function BotsInfos:GetBankBotIds(server)
    for _, bankBot in ipairs(self.bankBots) do
        if bankBot.server == server then
            return bankBot.botId
        end
    end
    return nil
end