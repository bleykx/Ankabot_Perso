ConfigsManager = {}

function ConfigsManager:new()
    local configManagerInstance = {}
    local configDirPath = global:getCurrentScriptDirectory()
    configManagerInstance.ConfigDirPath = string.match(configDirPath, "(.*\\)")
    configManagerInstance.ConfigDirPath = string.match(configDirPath, "(.*\\)")
    configManagerInstance.ConfigDirPath = configDirPath .. "Configs\\"
    setmetatable(configManagerInstance, self)
    self.__index = self
    return configManagerInstance
end

---@return string @Retourne le chemin du dossier de configuration.
---@param configName string @Nom du fichier de configuration.
function ConfigsManager:GetConfigByName(configName)
    return self.ConfigDirPath .. configName .. ".xml"
end

---@param bot nil|AccountController @instace du bot.
---@param configName string @Nom du fichier de configuration.
function ConfigsManager:InitConfig(bot, configName)
    local config = self:GetConfigByName(configName)
    bot:loadConfig(config)
    global:printColor("#00E8FF","Config "..config.." loaded for "..bot.character:name())
end