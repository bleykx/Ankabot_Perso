-- BotsManager = {}

-- function BotsManager:new()
--     dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Scripts\\ScriptsManager.lua")
--     dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Configs\\ConfigsManager.lua")
--     dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Proxys\\ProxysManager.lua")
--     dofile("C:\\ANKABOT\\Ankabot_Perso\\Domain\\Models\\Bot.lua")

--     local botInstance = {}
--     botInstance.ConfigsManager = ConfigsManager:new()
--     botInstance.ScriptsManager = ScriptsManager:new()
--     botInstance.ProxysManager = ProxysManager:new()
--     setmetatable(botInstance, self) 
--     self.__index = self
--     return botInstance
-- end

-- ---@param account table @Compte à lancer.
-- ---@return table @Retourne le bot lancé.
-- ---@param config string @Configuration à utiliser.
-- function BotsManager:StartBot(account, config)
--     local proxy = self.ProxysManager:GetProxyByUsername(account.username)
--     ankabotController:assignProxyToAnAccount(
--         proxy.username,
--         proxy.ip,
--         proxy.port,
--         proxy.proxyUsername,
--         proxy.proxyPassword,
--         proxy.https,
--         proxy.enabled
--     )

--     ankabotController:loadAccount(account.username,true)
--     local controler = ankabotController:getAccount(account.username)
    
--     if controler == nil then
--         global:printError("Impossible de charger le compte " .. account.username)
--         return nil
--     end
    
--     local bot = Bot:new(
--         controler,
--         account.botId,
--         account.botName,
--         account.username,
--         controler.character:level(),
--         nil
--     )

--     self.ConfigsManager:InitConfig(bot.Controler, config)
--     self.ScriptsManager:RunScript(bot.Controler)
--     bot.RunningScriptName = self.ScriptsManager:GetStepScript(bot.Controler).name
--     return bot
-- end

-- ---@param accounts table @Liste des comptes à lancer.
-- ---@param config string @Configuration à utiliser.
-- ---@return table bots @Retourne la liste des bots lancés.
-- function BotsManager:StartBots(accounts, config)
--     global:printColor("#00E8FF","Starting bots...")
--     local bots = {}
--     for _, account in ipairs(accounts) do
--         table.insert(bots, self:StartBot(account, config))
--     end

--     global:printColor("#00E8FF","Bots started")
--     return bots
-- end

-- ---@param bots table @Liste des bots à mettre à jour.
-- function BotsManager:UpdateBotsScript(bots)
--    for _, bot in ipairs(bots) do
--         local runningScriptName = bot.RunningScriptName

--         local script = self.ScriptsManager:GetStepScript(bot.Controler)
        
--         if script.name ~= runningScriptName or not bot.Controler:isScriptPlaying() then
--             bot.Controler:loadScript(script.path)
--             global:printColor("#00E8FF",script.name .. " charged for " .. bot.BotName)
--             bot.Controler:startScript()
--             global:printColor("#00E8FF",bot.BotName .. " started script " .. script.name)
--         end
--     end
-- end

-- function BotsManager:GetBankBotId(server)
--     for _, bankBot in ipairs(self.bankBots) do
--         if bankBot.server == server then
--             return bankBot.botId
--         end
--     end
--     return nil
-- end

-- function BotsManager:GetBankBotName(server)
--     for _, bankBot in ipairs(self.bankBots) do
--         if bankBot.server == server then
--             return bankBot.botName
--         end
--     end
--     return nil
-- end

-- function BotsManager:GetSellerBotId(server)
--     for _, sellerBot in ipairs(self.sellerBots) do
--         if sellerBot.server == server then
--             return sellerBot.botId
--         end
--     end
--     return nil
-- end

-- function BotsManager:GetSellerBotName(server)
--     for _, sellerBot in ipairs(self.sellerBots) do
--         if sellerBot.server == server then
--             return sellerBot.botName
--         end
--     end
--     return nil
-- end

-- function BotsManager:GetAllBots()
--     return self.otherBots
-- end

-- function BotsManager:GetAllBotsInfosByServer()
--     local allBotsByServer = {}
--     for _, bot in ipairs(self.otherBots) do
--         if allBotsByServer[bot.server] == nil then
--             allBotsByServer[bot.server] = {}
--         end
--         table.insert(allBotsByServer[bot.server], bot)
--     end
--     return allBotsByServer
-- end