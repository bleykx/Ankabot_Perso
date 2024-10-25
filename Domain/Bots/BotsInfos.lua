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

-- botInstance.sellerBots = {
--     { server = "Kernak", botId = 1141244206, botName = "Leheal" },
--     { server = "Koto", botId = 1666318634, botName = "Toadys" },
--     { server = "Manta", botId = 2030371116, botName = "Lapintch" },
--     { server = "Neray", botId = 1101529384, botName = "Eldiablo" },
--     { server = "Sorga", botId = 1281229099, botName = "Tvalide" },
--     { server = "Shanah", botId = 1799356717, botName = "Rafael" },
--     { server = "Tally", botId = 659423529, botName = "Ryan-Lepredator" },
--     { server = "Zag", botId = 1308950831, botName = "Marie" }
-- }

-- botInstance.otherBots = {
--      { server = "Imagiro", botId = 701942792483, botName = "Jean-crien" , username = "testbotdofus@outlook.fr"}
--      --{ server = "", botId = 0, botName = "" , username = "" }
--  }