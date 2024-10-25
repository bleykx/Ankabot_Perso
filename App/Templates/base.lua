AUTO_DELETE = {}
GATHER = {}
MIN_MONSTERS = 1
MAX_MONSTERS = 8


function move()
    return {
    }
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
    global:printError("Banned")
end

function mule_lost(bossMapId)
    global:printSuccess(bossMapId)
end