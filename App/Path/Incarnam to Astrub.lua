AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8

dofile(global:getCurrentScriptDirectory() .. "\\Domain\\Path\\PathManager.lua")

PathManager = PathManager:new()

function move()
    return PathManager:IncarnamToAstrub()
end

function bank()
    return {
    }
end

function phenix()
    return {
    }
end

function stopped()
end

function banned()
end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)
end