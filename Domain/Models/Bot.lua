Bot = {}

---@param controler AccountController
function Bot:new(controler, id, botName, username, level, runningScriptName)
    local botInstance = {}
    botInstance.Controler = controler
    botInstance.Id = id
    botInstance.BotName = botName
    botInstance.Username = username
    botInstance.Level = level
    botInstance.RunningScriptName = runningScriptName

    setmetatable(botInstance, self)
    self.__index = self
    return botInstance
end