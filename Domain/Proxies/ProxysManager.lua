ProxysManager = {}

function ProxysManager:new()
    dofile(global:getCurrentScriptDirectory() .. "\\Models\\Proxy.lua")
    local proxysInstance = {}
    proxysInstance.ProxysByBot = {
        Proxy:new("testbotdofus@outlook.fr", "37.143.3.46", 61234, "play302", "oLwhPhX6", true, true)
    }
    setmetatable(proxysInstance, self)
    self.__index = self
    return proxysInstance
end

---@param username string @Nom du compte.
---@return table @Retourne le proxy à lancer.
function ProxysManager:GetProxyByUsername(username)
    for _, proxy in ipairs(self.ProxysByBot) do
        if proxy.username == username then
            return proxy
        end
    end
    return nil
end
