ScriptsManager = {}

function ScriptsManager:new()
    local scriptInstance = {}
    local scriptDirPath = "C:\\ANKABOT\\Ankabot_Perso\\App\\"
    -- Initialisation de ScriptDirectory
    scriptInstance.Scripts = {
        { name = "UpIncarnam", area="Incarnam", path = scriptDirPath .. "\\COMBATS\\[INCARNAM] Drop aventurier - lvl 10 chasseur.lua", type = "Combat"}
    }
    setmetatable(scriptInstance, self)
    self.__index = self
    return scriptInstance
end

---@return table @Retourne la liste de tous les scripts.
function ScriptsManager:GetAllScripts()
    return self.Scripts
end

---@param scriptName string @Nom du script.
function ScriptsManager:GetScriptByName(scriptName)
    for _, script in ipairs(self.Scripts) do
        if script.name == scriptName then
            return script
        end
    end
    return nil
end

---@param bot AccountController @instace du bot.
---@return table @Retourne le script à lancer.
function ScriptsManager:GetStepScript(bot)
    if bot.character:level() < 12 then
        return self:GetScriptByName("UpIncarnam")
    end
    return nil
end

---@param bot AccountController @instace du bot.
function ScriptsManager:RunScript(bot)
    local script = self:GetStepScript(bot)
    bot:loadScript(script.path)
    bot:startScript()
    global:printColor("#00E8FF",bot.character:name() .. " started script " .. script.name)
end