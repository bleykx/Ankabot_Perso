BotsInfos = {}

function BotsInfos:New()
    local object = {}
    
    object.bankBots = {
        { server = "Sorga", botId = 1242759467},
        { server = "Tally", botId = 0},
        { server = "Zag", botId = 1308950831 }
    }

    setmetatable(object, self)
    self.__index = self
    return object
end

function BotsInfos:GetBankBotId(server)
    for _, bankBot in ipairs(self.bankBots) do
        if bankBot.server == server then
            return bankBot.botId
        end
    end
    return nil
end