Proxy = {}

function Proxy:new(username, ip, port, proxyUsername, proxyPassword, https, enabled)
    local proxyInstance = {}
    proxyInstance.username = username
    proxyInstance.ip = ip
    proxyInstance.port = port
    proxyInstance.proxyUsername = proxyUsername
    proxyInstance.proxyPassword = proxyPassword
    proxyInstance.https = https
    proxyInstance.enabled = enabled

    setmetatable(proxyInstance, self)
    self.__index = self
    return proxyInstance
end